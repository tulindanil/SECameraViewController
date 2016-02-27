//
//  SECornerView.m
//  Pods
//
//  Created by Danil Tulin on 2/25/16.
//
//

#import "SECornerView.h"

@interface SECornerView ()

@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) UIView *horizontalView;

@property (nonatomic, readwrite) SECornerViewType type;
@property (nonatomic, readwrite) CGRect rect;

@end

@implementation SECornerView

#pragma mark - life cycle

- (instancetype)initWithType:(SECornerViewType)type andRect:(CGRect)rect {
	if (self = [self initWithType:type]) {
		self.rect = rect;
	}
	return self;
}

- (instancetype)initWithType:(SECornerViewType)type {
	if (self = [self init]) {
		self.type = type;
	}
	return self;
}

- (instancetype)init {
	if (self = [super init]) {
		self.rect = CGRectMake(0, 0, 1, 20);
	}
	return self;
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	
	[self addSubview:self.verticalView];
	[self addSubview:self.horizontalView];
	
	[self setNeedsUpdateConstraints];
	
	[self setupConstraints];
}

- (void)setupConstraints {
	[self makeSizeFixed:self.verticalView];
	[self makeSizeFixed:self.horizontalView];
}

- (void)updateConstraints {
	
	if (self.type == SECornerViewTypeTopLeft) {
		[self.horizontalView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.top.equalTo(self);
		}];
		[self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.top.equalTo(self);
		}];
	} else if (self.type == SECornerViewTypeTopRight) {
		[self.horizontalView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.top.equalTo(self);
		}];
		[self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.top.equalTo(self);
		}];
	} else if (self.type == SECornerViewTypeBottomLeft) {
		[self.horizontalView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.bottom.equalTo(self);
		}];
		[self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.left.bottom.equalTo(self);
		}];
	} else {
		[self.horizontalView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.bottom.equalTo(self);
		}];
		[self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.bottom.equalTo(self);
		}];
	}
	
	[super updateConstraints];
}

- (void)makeSizeFixed:(UIView *)view {
	[view mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@(CGRectGetWidth(view.frame)));
		make.height.equalTo(@(CGRectGetHeight(view.frame)));
	}];
}

- (void)setRect:(CGRect)rect {
	_rect = rect;
	CGRect frame = self.frame;
	frame.size.width = CGRectGetHeight(rect);
	frame.size.height = CGRectGetHeight(rect);
	self.frame = frame;
}

#pragma mark - views

- (UIView *)verticalView {
	if (!_verticalView) {
		_verticalView = [SECornerView initializeView];
		_verticalView.frame = self.rect;
	}
	return _verticalView;
}

- (UIView *)horizontalView {
	if (!_horizontalView) {
		_horizontalView = [SECornerView initializeView];
		_horizontalView.frame = CGRectMake(0, 0,
										   CGRectGetHeight(self.rect),
										   CGRectGetWidth(self.rect));
	}
	return _horizontalView;
}

+ (UIView *)initializeView {
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor whiteColor];
	return view;
}

@end
