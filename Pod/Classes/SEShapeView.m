//
//  SEShapeView.m
//  Pods
//
//  Created by Danil Tulin on 4/2/16.
//
//

#import "SEShapeView.h"

@interface SEShapeView ()

@property (nonatomic) NSMutableArray *shapesToDraw;

@end

@implementation SEShapeView

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	self.backgroundColor = [UIColor clearColor];
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
	[self setNeedsDisplay];
}

- (void)clearShapes {
	[self.shapesToDraw removeAllObjects];
	[self setNeedsDisplay];
}

- (NSMutableArray *)shapesToDraw {
	if (_shapesToDraw)
		return _shapesToDraw;
	
	_shapesToDraw = [[NSMutableArray alloc] init];
	return _shapesToDraw;
}

@end
