//
//  SEShutterView.m
//  Pods
//
//  Created by Danil Tulin on 2/23/16.
//
//

#import "SEShutterView.h"

@interface SEShutterView ()

@property (nonatomic, readwrite) BOOL isOpen;

@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation SEShutterView

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	
	[self addSubview:self.upView];
	[self addSubview:self.bottomView];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self updateViewsFrame];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self updateViewsFrame];
}

#pragma mark - main api

- (void)open {
	[self openWithCompletion:nil];
}

- (void)close {
	[self closeWithCompletion:nil];
}

- (void)openWithCompletion:(void (^)())block {
	[self openWithDuration:defaultAnimationDuration
			withCompletion:block];
}
- (void)closeWithCompletion:(void (^)())block {
	[self closeWithDuration:defaultAnimationDuration
			 withCompletion:block];
}

- (void)openWithDuration:(CGFloat)duration
		  withCompletion:(void (^)())block {
	[self switchToState:YES
		   withDuration:duration
		 withCompletion:block];
}

- (void)closeWithDuration:(CGFloat)duration
		   withCompletion:(void (^)())block {
	[self switchToState:NO
		   withDuration:duration
		 withCompletion:block];
}

#pragma mark - inner logic

- (void)switchToState:(BOOL)state
		 withDuration:(CGFloat)duration
	   withCompletion:(void (^)())block {
	if (self.isOpen == state)
		return;
	
	self.isOpen = state;
	[UIView animateWithDuration:duration animations:^{
		[self updateViewsFrame];
	} completion:^(BOOL finished) {
		if (block != nil)
			block();
	}];
}

#pragma mark - views

- (void)updateViewsFrame {
	CGFloat height = self.isOpen ? 0 : CGRectGetHeight(self.frame)/2;
	CGFloat width = CGRectGetWidth(self.frame);
	
	NSLog(@"%f", height);
	
	CGFloat yBottomView = CGRectGetHeight(self.frame) - height;
	
	CGRect upFrame = CGRectMake(0, 0, width, height);
	CGRect bottomFrame = CGRectMake(0, yBottomView,
									width, height);
	
	self.upView.frame = upFrame;
	self.bottomView.frame = bottomFrame;
}

+ (UIView *)initializeView {
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor blackColor];
	return view;
}

#pragma mark - Up and Bottom views

- (UIView *)upView {
	if (!_upView) {
		_upView = [SEShutterView initializeView];
	}
	return _upView;
}

- (UIView *)bottomView {
	if (!_bottomView) {
		_bottomView = [SEShutterView initializeView];
	}
	return _bottomView;
}

@end
