//
//  SEPreviewView.m
//  Pods
//
//  Created by Danil Tulin on 2/25/16.
//
//

#import "SEPreviewView.h"

#import "SEPredscriptionView.h"

@interface SEPreviewView ()

@property (nonatomic, strong) SEPredscriptionView *predscriptionView;

@end

@implementation SEPreviewView

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	[self addSubview:self.predscriptionView];
}

- (void)updateConstraints {
	[self.predscriptionView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	[super updateConstraints];
}

#pragma mark - Predscription View

- (SEPredscriptionView *)predscriptionView {
	if (_predscriptionView)
		return _predscriptionView;
	
	_predscriptionView = [[SEPredscriptionView alloc] init];
	return _predscriptionView;
}

@end
