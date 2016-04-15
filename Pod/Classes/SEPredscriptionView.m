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

@property (nonatomic, strong) UILabel *predscriptionLabel;

@end

@implementation SEPredscriptionView

- (instancetype)init {
	if (self = [super init]) {
		_cornerViewOffset = CGPointMake(predscriptionViewCornerViewOffset,
											predscriptionViewCornerViewOffset);
	}
	return self;
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	
	[self addSubview:self.topLeft];
	[self addSubview:self.topRight];
	[self addSubview:self.bottomLeft];
	[self addSubview:self.bottomRight];
	
	[self addSubview:self.predscriptionLabel];
}

- (void)updateConstraints {
	[self.topLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
		[self makeSizeFixed:make
				   withView:self.topLeft];
		make.left.equalTo(self).offset(self.cornerViewOffset.x);
		make.top.equalTo(self).offset(self.cornerViewOffset.y);
	}];
	[self.topRight mas_remakeConstraints:^(MASConstraintMaker *make) {
		[self makeSizeFixed:make
				   withView:self.topRight];
		make.top.equalTo(self).offset(self.cornerViewOffset.y);
		make.right.equalTo(self).offset(-self.cornerViewOffset.x);
	}];
	[self.bottomLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
		[self makeSizeFixed:make
				   withView:self.bottomLeft];
		make.bottom.equalTo(self).offset(-self.cornerViewOffset.y);
		make.left.equalTo(self).offset(self.cornerViewOffset.x);
	}];
	[self.bottomRight mas_remakeConstraints:^(MASConstraintMaker *make) {
		[self makeSizeFixed:make
				   withView:self.bottomRight];
		make.right.equalTo(self).offset(-self.cornerViewOffset.x);
		make.bottom.equalTo(self).offset(-self.cornerViewOffset.y);
	}];
	
	[self.predscriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self);
	}];
	
	[super updateConstraints];
}

- (void)makeSizeFixed:(MASConstraintMaker *)make withView:(UIView *)view {
	make.width.equalTo(@(CGRectGetWidth(view.frame)));
	make.height.equalTo(@(CGRectGetHeight(view.frame)));
}

#pragma mark - CornerViewOffset

- (void)setCornerViewOffset:(CGPoint)cornerViewOffset {
	_cornerViewOffset = cornerViewOffset;
	[self layoutIfNeeded];
	[self setNeedsUpdateConstraints];
	[self updateConstraintsIfNeeded];
	[UIView animateWithDuration:defaultAnimationDuration
					 animations:^{
						 [self layoutIfNeeded];
	}];
}

#pragma mark - Prescription Label

- (UILabel *)predscriptionLabel {
	if (_predscriptionLabel)
		return _predscriptionLabel;
	
	_predscriptionLabel = [[UILabel alloc]
						   init];
	_predscriptionLabel.text = self.predscription;
	_predscriptionLabel.textColor = MP_HEX_RGB([primaryTextColor copy]);
	_predscriptionLabel.alpha = .0f;
	_predscriptionLabel.font = [UIFont systemFontOfSize:32.0f];
	
	return _predscriptionLabel;
}

- (void)showPredscriptionLabel:(BOOL)animated {
	[self setPredscriptionAlpha:1.0f animated:animated];
}

- (void)hidePredscriptionLabel:(BOOL)animated {
	[self setPredscriptionAlpha:.0f animated:animated];
}

- (void)setPredscriptionAlpha:(CGFloat)value animated:(BOOL)animated {
	if (animated) {
		[UIView animateWithDuration:defaultAnimationDuration
						 animations:^{
							 self.predscriptionLabel.alpha = value;
						 }];
	} else {
		self.predscriptionLabel.alpha = value;
	}
}

#pragma mark - Predscription

- (void)setPredscription:(NSString *)predscription {
	NSAssert(!self.superview, @"You must set predsription string before moving to superview");
	_predscription = predscription;
}

#pragma mark - orientation

- (void)rotatePredscriptionLabelForOrientation:(UIDeviceOrientation)orientation {
	switch (orientation) {
		case UIDeviceOrientationPortrait:
			self.predscriptionLabel.transform = CGAffineTransformMakeRotation(0);
			break;
		case UIDeviceOrientationLandscapeLeft:
			self.predscriptionLabel.transform = CGAffineTransformMakeRotation(.5f * M_PI);
			break;
		case UIDeviceOrientationLandscapeRight:
			self.predscriptionLabel.transform = CGAffineTransformMakeRotation(-.5f * M_PI);
			break;
		default:
			break;
	}
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
