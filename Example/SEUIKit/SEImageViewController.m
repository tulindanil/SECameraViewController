//
//  SEImageViewController.m
//  SEUIKit
//
//  Created by Danil Tulin on 3/21/16.
//  Copyright © 2016 tulindanil. All rights reserved.
//

#import "SEImageViewController.h"

@interface SEImageViewController ()

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIScrollView *scrollView;

@end

@implementation SEImageViewController

- (instancetype)initWithImage:(UIImage *)image {
	if (self = [super init]) {
		self.image = image;
	}
	return self;
}

- (void)updateViewConstraints {
	[self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.left.right.equalTo(self.view);
	}];
	
	[super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UINavigationBar *navigationBar = self.navigationController.navigationBar;
	
	navigationBar.barStyle = UIStatusBarStyleLightContent;
	navigationBar.translucent = NO;
	navigationBar.barTintColor = MP_HEX_RGB([darkPrimaryColor copy]);
	
	self.view.backgroundColor = MP_HEX_RGB([primaryColor copy]);
	
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:self.imageView];
	
	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
									initWithBarButtonSystemItem:(UIBarButtonSystemItemDone)
									target:self
									action:@selector(didTapCloseButton)];
	closeButton.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = closeButton;
	[self.view setNeedsUpdateConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Close Button Handler

- (void)didTapCloseButton {
	[self dismissViewControllerAnimated:YES
							 completion:nil];
}

#pragma mark - Scroll View

- (UIScrollView *)scrollView {
	if (_scrollView) {
		return _scrollView;
	}
	
	_scrollView = [[UIScrollView alloc] init];
	_scrollView.contentSize = self.imageView.bounds.size;
	
	return _scrollView;
}

#pragma mark - Image View

- (UIImageView *)imageView {
	if (_imageView) {
		return _imageView;
	}
	
	_imageView = [[UIImageView alloc]
				  initWithImage:self.image];
	CGRect bounds = CGRectZero;
	bounds.size = self.image.size;
	_imageView.bounds = bounds;
	
	return _imageView;
}

@end
