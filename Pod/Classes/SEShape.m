//
//  SEShape.m
//  Pods
//
//  Created by Danil Tulin on 3/21/16.
//
//

#import "SEShape.h"

@implementation SEPoint

- (instancetype)initWithPoint:(CGPoint)point {
	if (self = [super init]) {
		self.x = point.x;
		self.y = point.y;
	}
	return self;
}

@end

@interface SEShape ()

@property (nonatomic) NSMutableArray *internal;

@end

@implementation SEShape

- (instancetype)scaledShape:(CGSize)scaleFactor {
	SEShape *shape = [[SEShape alloc] init];
	
	CGFloat widthFactor = scaleFactor.width;
	CGFloat heightFactor = scaleFactor.height;
	
	for (NSUInteger i = 0; i < 4; i++) {
		SEPoint *point = [[SEPoint alloc] init];
		point.x = self[i].x * widthFactor;
		point.y = self[i].y * heightFactor;
		[shape insertPoint:point atIndex:i];
	}
	
	return shape;
}

- (SEPoint *)objectAtIndexedSubscript:(NSUInteger)idx {
	return self.internal[idx];
}

- (void)insertPoint:(SEPoint *)anObject atIndex:(NSUInteger)index {
	self.internal[index] = anObject;
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
	
	SEPoint *firstPoint = self[0];
	CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
	
	for (SEPoint *point in self.internal) {
		if (point == firstPoint)
			continue;
		[self addLineToPoint:point withContext:context];
	}
	[self addLineToPoint:firstPoint withContext:context];
	
	CGContextStrokePath(context);
}

- (void)addLineToPoint:(SEPoint *)point
			withContext:(CGContextRef)context {
	CGContextAddLineToPoint(context, point.x, point.y);
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
