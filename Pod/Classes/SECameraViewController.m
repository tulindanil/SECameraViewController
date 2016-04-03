//
//  SECameraViewController.m
//  Pods
//
//  Created by Danil Tulin on 1/26/16.
//
//

#import <Accelerate/Accelerate.h>

#import "SECameraViewController.h"

#import "SEVision.h"

#import "SEPreviewView.h"
#import "SEShutterView.h"
#import "SERoundButtonsContainer.h"

@interface SECameraViewController () <SEVisionDelegate>

@property (nonatomic, strong) SEPreviewView *previewView;
@property (nonatomic, strong) SEShutterView *shutterView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) SEVision *vision;

@property (nonatomic, getter=isAppeared) BOOL appeared;

@property (nonatomic, strong) SERoundButtonsContainer *buttonsContainer;

@property (nonatomic, strong) UIButton *lightButton;

@property (nonatomic) UIDeviceOrientation orientation;

@end

@implementation SECameraViewController

#pragma mark - Life Cycle

- (instancetype)initWithDelegate:(id<SECameraViewControllerDelegate>)delegate {
	if (self = [super init]) {
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = MP_HEX_RGB([darkPrimaryColor copy]);
	
	[self.view addSubview:self.previewView];
	[self.view addSubview:self.closeButton];
	
	[self.vision startPreview];
	[self.view setNeedsUpdateConstraints];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.vision.previewLayer.frame = self.previewView.bounds;
	[self.previewView bringSubviewToFront:self.shutterView];
}

- (void)updateViewConstraints {
	[self.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
		if (self.outputFormat == SEOutputFormatSquare) {
			make.center.equalTo(self.view);
			make.width.equalTo(self.view);
			make.height.equalTo(self.previewView.mas_width);
		} else if (self.outputFormat == SEOutputFormatWidescreen) {
			make.top.left.right.equalTo(self.view);
			make.bottom.equalTo(self.closeButton.mas_top);
		}
	}];
	
	[self.shutterView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.previewView);
	}];
	
	[self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(self.view.mas_width);
		make.bottom.equalTo(self.view.mas_bottom);
		make.height.equalTo(@(50));
	}];
	
//	[self.buttonsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.equalTo(self.closeButton.mas_top).offset(-8);
//		make.centerX.equalTo(self.view.mas_centerX);
//	}];
	[super updateViewConstraints];
}

- (void)executeIfLandscape:(void(^)(void))landscapeBlock ifPortrait:(void(^)(void))portraitBlock {
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) && landscapeBlock != nil) {
		landscapeBlock();
	} else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && portraitBlock != nil) {
		portraitBlock();
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.appeared = YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didChangeOrientation)
												 name:UIDeviceOrientationDidChangeNotification
											   object:nil];
	[self didChangeOrientation];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.shutterView close];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.vision stopPreview];
	[self.engine stopSession];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIDeviceOrientationDidChangeNotification
												  object:nil];
}

#pragma mark - Draw Shape

- (SEShape *)convertShape:(SEShape *)shape {
	if (self.orientation == UIDeviceOrientationLandscapeLeft ||
		self.orientation == UIDeviceOrientationLandscapeRight) {
		return [[SEShape alloc] initConvertedWithShape:shape];
	} else {
		return shape;
	}
}

- (void)addShape:(SEShape *)shape {
	SEShape *convertedShape = [self convertShape:shape];
	
	CGSize previewSize = self.previewView.frame.size;
	CGSize outputSize = self.vision.outputSize;
	
	CGFloat outputHeight = outputSize.width; // according to preview view's portrait size
	CGFloat outputWidth = outputSize.height;
	
	CGFloat factor = previewSize.width / outputWidth;
	
	CGFloat offset = (outputHeight - previewSize.height / factor) / 2;
	
	[convertedShape transformXCoordinate:factor withOffset:.0f];
	[convertedShape transformYCoordinate:factor withOffset:-offset];
	
	[self.previewView addShape:convertedShape];
}

- (void)clearShapes {
	[self.previewView clearShapes];
}

#pragma mark - Orientation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

- (UIDeviceOrientation)orientation {
	UIDevice *device = [UIDevice currentDevice];
	return device.orientation;
}

- (void)didChangeOrientation {
	UIDeviceOrientation orientation = self.orientation;
	
	[UIView animateWithDuration:defaultAnimationDuration animations:^{
		[self.previewView.predscriptionView rotatePredscriptionLabelForOrientation:orientation];
	}];
}

#pragma mark - CloseButton

- (UIButton *)closeButton {
	if (_closeButton)
		return _closeButton;
	
	_closeButton = [[UIButton alloc] init];
	[_closeButton setBackgroundColor:MP_HEX_RGB([defaultPrimaryColor copy])];
	[_closeButton setTitle:[NSLocalizedString(@"Close", nil) uppercaseString]
				  forState:UIControlStateNormal];
	[_closeButton addTarget:self
					 action:@selector(didTapCloseButton:)
		   forControlEvents:UIControlEventTouchUpInside];
	
	return _closeButton;
}

- (void)didTapCloseButton:(id)sender {
	[self dismissViewControllerAnimated:YES completion:^{
		if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidTapCloseButton:)]) {
			[self.delegate cameraViewControllerDidTapCloseButton:self];
		}
	}];
}

#pragma mark - PreviewView

- (UIView *)previewView {
	if (_previewView)
		return _previewView;
	
	_previewView = [[SEPreviewView alloc] init];
	_previewView.backgroundColor = [UIColor blackColor];
	_previewView.predscriptionView.predscription = @"PLACE";
	
	AVCaptureVideoPreviewLayer *previewLayer = self.vision.previewLayer;
	[_previewView.layer addSublayer:previewLayer];
	
	_shutterView = [[SEShutterView alloc] init];
	[_previewView addSubview:_shutterView];
	
	return _previewView;
}

#pragma mark - Vision

- (SEVision *)vision {
	if (_vision)
		return _vision;
	
	_vision = [SEVision sharedInstance];
	_vision.delegate = self;
	
	return _vision;
}

#pragma mark - Vision Delegate

- (void)visionSessionDidStartPreview:(SEVision *)vision {
	[self.shutterView openWithCompletion:^{
		[self.previewView.predscriptionView showPredscriptionLabel:YES];
		[self.engine startSession];
	}];
}

- (void)vision:(SEVision *)vision
didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
	CVImageBufferRef imageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
	CVPixelBufferLockBaseAddress(imageBufferRef, 0);
	
	NSUInteger width = 0, height = 0;
	
	NSData *data = [self rotateBuffer:imageBufferRef
								width:&width
							   height:&height];
	
	[self.engine feedBGRAImageData:data
							 width:width
							height:height];
	
	if ([self.delegate respondsToSelector:@selector(cameraViewController:
													didCaptureBGRASampleData:
													width:
													height:)]) {
		[self.delegate cameraViewController:self
				   didCaptureBGRASampleData:data
									  width:width
									 height:height];
	}
	
	if ([self.delegate respondsToSelector:@selector(cameraViewController:
													didCaptureVideoSampleBuffer:)]) {
		[self.delegate cameraViewController:self
				didCaptureVideoSampleBuffer:sampleBuffer];
	}
}

- (NSData *)rotateBuffer:(const CVImageBufferRef)imageBufferRef
				   width:(NSUInteger *)width
				  height:(NSUInteger *)height {
	*width = CVPixelBufferGetWidth(imageBufferRef);
	*height = CVPixelBufferGetHeight(imageBufferRef);
	size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBufferRef);
	size_t currSize = bytesPerRow * *height;
	size_t bytesPerRowOut = bytesPerRow;

	void *srcBuff = CVPixelBufferGetBaseAddress(imageBufferRef);
	
	NSUInteger rotationConstant = [self getOrientationConstant];
	unsigned char *outBuff = (unsigned char*)malloc(currSize);
	
	vImage_Buffer ibuff = {srcBuff, *height, *width, bytesPerRow};

	if (rotationConstant % 2 != 0) {
		NSUInteger tmp = *width;
		*width = *height;
		*height = tmp;
		bytesPerRowOut = 4 * *width;
	}
	
	vImage_Buffer ubuff = {outBuff, *height, *width, bytesPerRowOut};
	
	Pixel_8888 backColor = {0, 0, 0, 0};
	vImage_Error err = vImageRotate90_ARGB8888(&ibuff,
											   &ubuff,
											   rotationConstant,
											   backColor,
											   0);
	if (err != kvImageNoError)
		NSLog(@"%ld", err);

	return [NSData dataWithBytesNoCopy:outBuff
								length:currSize
								freeWhenDone:YES];
}

- (NSUInteger)getOrientationConstant {
	switch (self.orientation) {
		case UIDeviceOrientationPortrait:
			return 3;
			break;
		case UIDeviceOrientationLandscapeRight:
			return 2;
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			return 1;
			break;
		case UIDeviceOrientationLandscapeLeft:
			return 0;
			break;
  		default:
			break;
	}
	return 0;
}

#pragma mark - OutputFormat

- (void)setOutputFormat:(SEOutputFormat)outputFormat {
	NSAssert(!self.isAppeared, @"Setting ouput format must be before loading view");
	_outputFormat = outputFormat;
}

#pragma mark - Flash Enabled

- (void)setFlashEnabled:(BOOL)flashEnabled {
	NSAssert(!self.isAppeared, @"Setting flash avalaibality format must be before loading view");
	_flashEnabled = flashEnabled;
}

#pragma mark - Buttons Container

- (SERoundButtonsContainer *)buttonsContainer {
	if (_buttonsContainer) {
		return _buttonsContainer;
	}
	
	_buttonsContainer = [[SERoundButtonsContainer alloc] init];
	
	if (self.isFlashEnabled) {
		[_buttonsContainer addButton:self.lightButton];
	}
	
	return _buttonsContainer;
}

- (UIButton *)lightButton {
	if (_lightButton) {
		return _lightButton;
	}
	
	_lightButton = [[UIButton alloc] init];
	[_lightButton setTitle:@"Light" forState:UIControlStateNormal];
	[_lightButton sizeToFit];
	
	return _lightButton;
}

#pragma mark - UIViewController

- (void)viewWillTransitionToSize:(CGSize)size
	   withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator  {
	[super viewWillTransitionToSize:size
		  withTransitionCoordinator:coordinator];
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

@end
