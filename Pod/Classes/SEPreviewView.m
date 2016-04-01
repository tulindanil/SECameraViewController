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

@property (nonatomic, readwrite) SEPredscriptionView *predscriptionView;

@property (nonatomic) NSMutableArray *shapesToDraw;

@end

@implementation SEPreviewView

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	[self addSubview:self.predscriptionView];
}

- (void)updateConstraints {
	[self.predscriptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
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

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	for (SEShape *shape in self.shapesToDraw) {
		[shape drawInContext:context];
	}
}

#pragma mark - Shape

- (void)addShape:(SEShape *)shape {
	[self.shapesToDraw addObject:shape];
}

- (void)clearShapes {
	[self.shapesToDraw removeAllObjects];
}

- (NSMutableArray *)shapesToDraw {
	if (_shapesToDraw)
		return _shapesToDraw;
	
	_shapesToDraw = [[NSMutableArray alloc] init];
	return _shapesToDraw;
}

#pragma mark - Predscription View

- (SEPredscriptionView *)predscriptionView {
	if (_predscriptionView)
		return _predscriptionView;
	
	_predscriptionView = [[SEPredscriptionView alloc] init];
	return _predscriptionView;
}

@end
