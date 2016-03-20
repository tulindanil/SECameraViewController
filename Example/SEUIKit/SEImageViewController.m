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
	
	self.navigationController.navigationBar.translucent = NO;
	
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll View

- (UIScrollView *)scrollView {
	if (_scrollView) {
		return _scrollView;
	}
	
	_scrollView = [[UIScrollView alloc] init];
	_scrollView.contentSize = self.imageView.frame.size;
	
	return _scrollView;
}

#pragma mark - Image View

- (UIImageView *)imageView {
	if (_imageView) {
		return _imageView;
	}
	
	_imageView = [[UIImageView alloc]
				  initWithImage:self.image];
	CGRect bounds;
	bounds.size = self.image.size;
	_imageView.bounds = bounds;
	
	return _imageView;
}

@end
