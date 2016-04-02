//
//  SEPreviewView.m
//  Pods
//
//  Created by Danil Tulin on 2/25/16.
//
//

#import "SEPreviewView.h"

#import "SEShapeView.h"
#import "SEPredscriptionView.h"

@interface SEPreviewView ()

@property (nonatomic, readwrite) SEPredscriptionView *predscriptionView;

@property (nonatomic) SEShapeView *shapeView;

@property (nonatomic) NSMutableArray *shapesToDraw;

@end

@implementation SEPreviewView

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	[self addSubview:self.predscriptionView];
	[self addSubview:self.shapeView];
}

- (void)updateConstraints {
	[self.predscriptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	[self.shapeView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	[super updateConstraints];
}

- (void)showPredscriptionLabel:(BOOL)animated {
	[self.predscriptionView showPredscriptionLabel:animated];
}

- (void)hidePredscriptionLabel:(BOOL)animated {
	[self.predscriptionView hidePredscriptionLabel:animated];
}

- (void)rotatePredscriptionLabelForOrientation:(UIDeviceOrientation)orientation {
	[self.predscriptionView rotatePredscriptionLabelForOrientation:orientation];
}

#pragma mark - Shape

- (void)addShape:(SEShape *)shape {
	[self.shapeView addShape:shape];
}

- (void)clearShapes {
	[self.shapeView clearShapes];
}

- (SEShape *)shapeView {
	if (_shapeView)
		return _shapeView;
	
	_shapeView = [[SEShapeView alloc] init];
	return _shapeView;
}

#pragma mark - Predscription View

- (SEPredscriptionView *)predscriptionView {
	if (_predscriptionView)
		return _predscriptionView;
	
	_predscriptionView = [[SEPredscriptionView alloc] init];
	return _predscriptionView;
}

@end
