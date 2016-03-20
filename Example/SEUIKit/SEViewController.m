//
//  SEViewController.m
//  SEUIKit
//
//  Created by tulindanil on 01/26/2016.
//  Copyright (c) 2016 tulindanil. All rights reserved.
//

#import "SEViewController.h"
#import "SEImageViewController.h"

@interface SEViewController () <SECameraViewControllerDelegate>

@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic) UIImage *lastCapturedImage;

@end

@implementation SEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	UINavigationBar *navigationBar = self.navigationController.navigationBar;
	
	navigationBar.barStyle = UIStatusBarStyleLightContent;
	navigationBar.translucent = NO;
	navigationBar.barTintColor = MP_HEX_RGB([defaultPrimaryColor copy]);
	
	self.view.backgroundColor = MP_HEX_RGB([darkPrimaryColor copy]);
	
	[self.view setNeedsUpdateConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.view addSubview:self.cameraButton];
}

- (void)updateViewConstraints {
	[super updateViewConstraints];
	
	[self.cameraButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
	}];
}

#pragma mark - Camera Button

- (UIButton *)cameraButton {
	if (_cameraButton)
		return _cameraButton;
	
	_cameraButton = [[UIButton alloc] init];
	[_cameraButton setTitle:@"Use Camera"
				   forState:UIControlStateNormal];
	[_cameraButton addTarget:self
					  action:@selector(didTapCamera:)
			forControlEvents:UIControlEventTouchUpInside];
	
	return _cameraButton;
}

- (void)didTapCamera:(id)sender {
	SECameraViewController *cameraViewController = [[SECameraViewController alloc]
													init];
	cameraViewController.delegate = self;
	cameraViewController.outputFormat = SEOutputFormatSquare;
	cameraViewController.flashEnabled = YES;
	[self presentViewController:cameraViewController
					   animated:YES
					 completion:nil];
}

#pragma mark - SECameraViewConrtollerDelegate

- (void)cameraViewControllerDidTapCloseButton:(SECameraViewController *)cameraViewController {
	SEImageViewController *imageVC = [[SEImageViewController alloc]
									  initWithImage:self.lastCapturedImage];
	UINavigationController *navigationController = [[UINavigationController alloc]
													initWithRootViewController:imageVC];
	[self presentViewController:navigationController
					   animated:YES
					 completion:nil];
}

- (void)cameraViewController:(SECameraViewController *)cameraViewController
 didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
	
}

- (void)cameraViewController:(SECameraViewController *)cameraViewController
	didCaptureBGRASampleData:(const u_int8_t *)bytes
					   width:(NSUInteger)width
					  height:(NSUInteger)height {
	static dispatch_once_t predicate = 0;
	dispatch_once(&predicate, ^(){
		NSLog(@"Width: %zu, Height: %zu", (unsigned long)width, (unsigned long)height);
	});
	
	NSUInteger dataLength = width * height * 4;
	
	NSMutableData *data = [NSMutableData dataWithBytes:bytes
												length:dataLength];
	
	char *mutableBytes = data.mutableBytes;
	
	for (NSUInteger i = 0; i < dataLength; i += 4) {
		char blueByte = mutableBytes[i];
		mutableBytes[i] = mutableBytes[i + 2]; // blue <- red
		mutableBytes[i + 2] = blueByte;        // red <- blue
	} // BGRA -> RGBA

	self.lastCapturedImage = [self createImageFromRGBAData:data
													 width:width
													height:height];
}

- (UIImage *)createImageFromRGBAData:(NSData *)data
							   width:(NSUInteger)width
							  height:(NSUInteger)height {
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef imageRef = CGImageCreate(width, // Width
										height, // Height
										8, // Bits per component
										32, // Bits per pixel
										width * 4, // Bytes per row
										colorSpace, // Colorspace
										kCGImageAlphaLast |  kCGBitmapByteOrderDefault, // Bitmap info flags
										provider, // CGDataProviderRef
										NULL, // Decode
										false, // Should interpolate
										kCGRenderingIntentDefault); // Intent
	
	UIImage *ret = [UIImage imageWithCGImage:imageRef
									   scale:1.0f
								 orientation:UIImageOrientationDown];
	
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	
	return ret;
}

@end
