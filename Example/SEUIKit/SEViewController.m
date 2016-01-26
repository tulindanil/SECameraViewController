//
//  SEViewController.m
//  SEUIKit
//
//  Created by tulindanil on 01/26/2016.
//  Copyright (c) 2016 tulindanil. All rights reserved.
//

#import "SEViewController.h"

#import <SEUIKit/SECameraViewController.h>

@interface SEViewController ()

@property (nonatomic, strong) UIButton *cameraButton;

@end

@implementation SEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Camera Button

- (UIButton *)cameraButton {
	if (_cameraButton)
		return _cameraButton;
		
	_cameraButton = [[UIButton alloc] init];
	return _cameraButton;
}

@end
