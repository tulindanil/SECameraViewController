//
//  SEPredscriptionVIew.m
//  Pods
//
//  Created by Danil Tulin on 2/25/16.
//
//

#import "SEPredscriptionView.h"

#import "SECornerView.h"

@interface SEPredscriptionView ()

@property (nonatomic, strong) SECornerView *topLeft;
@property (nonatomic, strong) SECornerView *topRight;
@property (nonatomic, strong) SECornerView *bottomLeft;
@property (nonatomic, strong) SECornerView *bottomRight;

@end

@implementation SEPredscriptionView

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	
	[self addSubview:self.topLeft];
	[self addSubview:self.topRight];
	[self addSubview:self.bottomLeft];
	[self addSubview:self.bottomRight];
}

- (void)updateConstraints {
	[self.topLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
		[self makeSizeFixed:make
				   withView:self.topLeft];
		make.left.top.equalTo(self).offset(predscriptionViewCornerViewOffset);
	}];
	[self.topRight mas_remakeConstraints:^(MASConstraintMaker *make) {
		[self makeSizeFixed:make
				   withView:self.topRight];
		make.top.equalTo(self).offset(predscriptionViewCornerViewOffset);
		make.right.equalTo(self).offset(-predscriptionViewCornerViewOffset);
	}];
	[self.bottomLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
		[self makeSizeFixed:make
				   withView:self.bottomLeft];
		make.bottom.equalTo(self).offset(-predscriptionViewCornerViewOffset);
		make.left.equalTo(self).offset(predscriptionViewCornerViewOffset);
	}];
	[self.bottomRight mas_remakeConstraints:^(MASConstraintMaker *make) {
		[self makeSizeFixed:make
				   withView:self.bottomRight];
		make.right.bottom.equalTo(self).offset(-predscriptionViewCornerViewOffset);
	}];
	
	[super updateConstraints];
}

- (void)makeSizeFixed:(MASConstraintMaker *)make withView:(UIView *)view {
	make.width.equalTo(@(CGRectGetWidth(view.frame)));
	make.height.equalTo(@(CGRectGetHeight(view.frame)));
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

#pragma mark - Corner Views

- (SECornerView *)topLeft {
	if (_topLeft)
		return _topLeft;
	
	_topLeft = [[SECornerView alloc]
				initWithType:SECornerViewTypeTopLeft];
	
	return _topLeft;
}

- (SECornerView *)topRight {
	if (_topRight)
		return _topRight;
	
	_topRight = [[SECornerView alloc]
				 initWithType:SECornerViewTypeTopRight];
	
	return _topRight;
}

- (SECornerView *)bottomLeft {
	if (_bottomLeft)
		return _bottomLeft;
	
	_bottomLeft = [[SECornerView alloc]
				   initWithType:SECornerViewTypeBottomLeft];
	
	return _bottomLeft;
}

- (SECornerView *)bottomRight {
	if (_bottomRight)
		return _bottomRight;
	
	_bottomRight = [[SECornerView alloc]
					initWithType:SECornerViewTypeBottomRight];
	
	return _bottomRight;
}

@end
