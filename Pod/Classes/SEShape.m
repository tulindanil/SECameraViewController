//
//  SEShape.m
//  Pods
//
//  Created by Danil Tulin on 3/21/16.
//
//

#import "SEShape.h"

@implementation SEPoint

- (instancetype)initWithCGPoint:(CGPoint)point {
	if (self = [super init]) {
		self.x = point.x;
		self.y = point.y;
	}
	return self;
}

- (instancetype)initWithPoint:(SEPoint *)point {
	if (self = [super init]) {
		self.x = point.x;
		self.y = point.y;
	}
	return self;
}

- (instancetype)initConvertedWithPoint:(SEPoint *)point {
	if (self = [super init]) {
		self.x = point.y;
		self.y = point.x;
	}
	return self;
}

@end

@interface SEShape ()

@property (nonatomic) NSMutableArray *internal;

@end

@implementation SEShape

- (instancetype)initWithShape:(SEShape *)shape {
	if (self = [super init]) {
		for (SEPoint *point in shape.internal) {
			[self.internal addObject:point];
		}
	}
	return self;
}

- (instancetype)initConvertedWithShape:(SEShape *)shape
						andOrientation:(UIDeviceOrientation)orientation {
	if (self = [super init]) {
		for (SEPoint *point in shape.internal) {
			SEPoint *convertedPoint = [[SEPoint alloc] init];
			if (orientation == UIDeviceOrientationLandscapeLeft) {
				convertedPoint.x = -point.y;
				convertedPoint.y = point.x;
			} else if (orientation == UIDeviceOrientationLandscapeRight) {
				convertedPoint.x = point.y;
				convertedPoint.y = -point.x;
			} else {
				convertedPoint.x = point.x;
				convertedPoint.y = point.y;
			}
			NSUInteger index = [shape.internal indexOfObject:point];
			self.internal[index] = convertedPoint;
		}
	}
	return self;
}

- (void)transformXCoordinate:(CGFloat)factor withOffset:(CGFloat)offset {
	for (SEPoint *point in self.internal) {
		point.x += offset;
		point.x *= factor;
	}
}

- (void)transformYCoordinate:(CGFloat)factor withOffset:(CGFloat)offset {
	for (SEPoint *point in self.internal) {
		point.y += offset;
		point.y *= factor;
	}
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
