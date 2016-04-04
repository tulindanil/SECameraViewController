//
//  SEShape.h
//  Pods
//
//  Created by Danil Tulin on 3/21/16.
//
//

#import <Foundation/Foundation.h>

@interface SEPoint : NSObject

- (instancetype)initWithCGPoint:(CGPoint)point;
- (instancetype)initWithPoint:(SEPoint *)point;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@end

@interface SEShape : NSObject

- (instancetype)initWithShape:(SEShape *)shape;
- (instancetype)initConvertedWithShape:(SEShape *)shape
						   orientation:(UIDeviceOrientation)orientation
								  size:(CGSize)size;

- (SEPoint *)objectAtIndexedSubscript:(NSUInteger)idx;

- (void)transformXCoordinate:(CGFloat)factor withOffset:(CGFloat)offset;
- (void)transformYCoordinate:(CGFloat)factor withOffset:(CGFloat)offset;

- (void)insertPoint:(SEPoint *)anObject atIndex:(NSUInteger)index;
- (void)drawInContext:(CGContextRef)context
			withColor:(UIColor *)color;

@end