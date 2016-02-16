//
//  SECameraViewController.m
//  Pods
//
//  Created by Danil Tulin on 1/26/16.
//
//

#import "SECameraViewController.h"

#import <PBJVision/PBJVision.h>

@interface SECameraViewController () <PBJVisionDelegate>

@property (nonatomic, readwrite) AVCaptureVideoPreviewLayer *previewLayer;

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
}

#pragma mark - Vision

- (PBJVision *)vision {
	if (_vision) return _vision;
	
	_vision = [[PBJVision alloc] init];
	_vision.delegate = self;
	
	return _vision;
}

#pragma mark - Vision Delegate



#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
