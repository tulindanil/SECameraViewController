//
//  SEViewController.m
//  SEUIKit
//
//  Created by tulindanil on 01/26/2016.
//  Copyright (c) 2016 tulindanil. All rights reserved.
//

#import "SEViewController.h"

@interface SEViewController () <SECameraViewControllerDelegate>

@property (nonatomic, strong) UIButton *cameraButton;

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

- (void)cameraViewController:(SECameraViewController *)cameraViewController
 didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
	
	static dispatch_once_t predicate = 0;
	dispatch_once(&predicate, ^(){
		CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
		
		CVPixelBufferLockBaseAddress(imageBuffer, 0);
		
		int width = (int)CVPixelBufferGetWidth(imageBuffer);
		int height = (int)CVPixelBufferGetHeight(imageBuffer);
		
		NSLog(@"Width: %d, Height: %d", width, height);
	});
}

@end
