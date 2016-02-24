//
//  SECameraViewController.m
//  Pods
//
//  Created by Danil Tulin on 1/26/16.
//
//

#import "SECameraViewController.h"

#import <PBJVision/PBJVision.h>

#import "SEShutterView.h"

@interface SECameraViewController () <PBJVisionDelegate>

@property (nonatomic, readwrite) UIView *previewView;
@property (nonatomic, strong) SEShutterView *shutterView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) PBJVision *vision;

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
	[self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.shutterView openWithCompletion:^{
		[self.vision startPreview];
	}];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.vision.previewLayer.frame = self.previewLayer.bounds;
}

- (void)updateViewConstraints {
	[super updateViewConstraints];
	
	[self.previewView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.center.equalTo(self.view);
		make.height.equalTo(self.previewView.mas_width);
	}];
	
	[self.shutterView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.previewView);
	}];
	
	[self.closeButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.equalTo(self.view);
		make.height.equalTo(@(bottomToolbarHeight));
	}];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.vision stopPreview];
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
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissViewControllerAnimated:(BOOL)flag
						   completion:(void (^)(void))completion {
	[self.shutterView closeWithCompletion:^{
		[super dismissViewControllerAnimated:flag
								  completion:completion];
	}];
}

#pragma mark - PreviewView

- (UIView *)previewView {
	if (_previewView)
		return _previewView;
	
	_previewView = [[UIView alloc] init];
	_previewView.backgroundColor = [UIColor greenColor];
	
	AVCaptureVideoPreviewLayer *previewLayer = self.vision.previewLayer;
	previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[_previewView.layer addSublayer:previewLayer];
	
	_shutterView = [[SEShutterView alloc] init];
	[_previewView addSubview:_shutterView];
	
	return _previewView;
}

#pragma mark - Vision

- (PBJVision *)vision {
	if (_vision)
		return _vision;
	
	_vision = [PBJVision sharedInstance];
	_vision.delegate = self;
	
	_vision.cameraMode = PBJCameraModeVideo;
	_vision.cameraOrientation = PBJCameraOrientationPortrait;
	_vision.focusMode = PBJFocusModeContinuousAutoFocus;
	
	_vision.outputFormat = PBJOutputFormatSquare;
	
	return _vision;
}

#pragma mark - Vision Delegate

- (void)vision:(PBJVision *)vision
didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
	[self.delegate cameraViewController:self
			didCaptureVideoSampleBuffer:sampleBuffer];
}

#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
