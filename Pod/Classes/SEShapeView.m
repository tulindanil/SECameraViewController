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
@property (nonatomic) NSMutableArray *shapesColors;

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
		NSUInteger index = [self.shapesToDraw indexOfObject:shape];
		[shape drawInContext:context
				   withColor:self.shapesColors[index]];
	}
}

#pragma mark - Shape

- (void)addShape:(SEShape *)shape
	   withColor:(UIColor *)color {
	[self.shapesToDraw addObject:shape];
	[self.shapesColors addObject:color];
	[self setNeedsDisplay];
}

- (void)clearShapes {
	[self.shapesToDraw removeAllObjects];
	[self.shapesColors removeAllObjects];
	[self setNeedsDisplay];
}

- (NSMutableArray *)shapesToDraw {
	if (_shapesToDraw)
		return _shapesToDraw;
	
	_shapesToDraw = [[NSMutableArray alloc] init];
	return _shapesToDraw;
}

- (NSMutableArray *)shapesColors {
	if (_shapesColors)
		return _shapesColors;
	
	_shapesColors = [[NSMutableArray alloc] init];
	return _shapesColors;
}

@end
