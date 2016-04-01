//
//  SEShape.m
//  Pods
//
//  Created by Danil Tulin on 3/21/16.
//
//

#import "SEShape.h"

@interface SEShape ()

@property (nonatomic) NSMutableArray *internal;

@end

@implementation SEShape

- (instancetype)scaledShape:(CGSize)scaleFactor {
	SEShape *shape = [[SEShape alloc] init];
	
	CGFloat widthFactor = scaleFactor.width;
	CGFloat heightFactor = scaleFactor.height;
	
	for (SEPoint *point in self.internal) {
		point.x *= widthFactor;
		point.y *= heightFactor;
	}
	
	return shape;
}

- (SEPoint *)objectAtIndexedSubscript:(NSUInteger)idx {
	return self.internal[idx];
}

#pragma mark - drawing

- (void)drawInContext:(CGContextRef)context {
	CGContextSetLineWidth(context, 1.5f);
	CGContextSetAlpha(context, 0.8f);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	
	CGContextSetLineWidth(context, 1.0f);
	
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextBeginPath(context);
	
	for (SEPoint *point in self.internal) {
		CGContextAddLineToPoint(context, point.x, point.y);
	}
	
	CGContextStrokePath(context);
}

#pragma mark - Internal

- (NSMutableArray *)internal {
	if (_internal)
		return _internal;
	
	_internal = [[NSMutableArray alloc] initWithCapacity:4];
	for (NSUInteger i = 0; i < 4; ++i) {
		[_internal addObject:[[SEPoint alloc] init]];
	}
	return _internal;
}

@end
