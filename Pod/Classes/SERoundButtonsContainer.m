//
//  SERoundButtonsContainer.m
//  Pods
//
//  Created by Danil Tulin on 2/28/16.
//
//

#import "SERoundButtonsContainer.h"

@interface SERoundButtonsContainer ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation SERoundButtonsContainer

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	[self addSubview:self.container];
	
	self.backgroundColor = [UIColor blackColor];
	self.alpha = .5f;
}

- (void)updateConstraints {
	UIButton *previousButton = nil;
	for (UIButton *button in self.buttons) {
		[button mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.width.equalTo(@(CGRectGetWidth(button.bounds)));
			make.height.equalTo(@(CGRectGetHeight(button.bounds)));
			if (previousButton) {
				make.left.equalTo(previousButton.mas_right);
			} else {
				make.left.equalTo(self.container);
			}
			make.centerY.equalTo(self.container);
		}];
		previousButton = button;
	}
	
	if (previousButton) {
		
		[self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.right.equalTo(previousButton);
			make.center.equalTo(self);
		}];
		
		[self mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.width.height.equalTo(self.container).sizeOffset(SERoundButtonsContainerOffset);
		}];
	}
	
	[super updateConstraints];
}

- (void)layoutSubviews {
	self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
	[super layoutSubviews];
}

#pragma mark - add buttons method

- (void)addButton:(UIButton *)button {
	[self.buttons addObject:button];
	[self.container addSubview:button];
	[self setNeedsUpdateConstraints];
}

#pragma mark - container

- (UIView *)container {
	if (_container) {
		return _container;
	}
	
	_container = [[UIView alloc] init];
	return _container;
}

#pragma mark - Buttons Getter

- (NSMutableArray *)buttons {
	if (_buttons) {
		return _buttons;
	}
	
	_buttons = [[NSMutableArray alloc] init];
	
	return _buttons;
}

@end
