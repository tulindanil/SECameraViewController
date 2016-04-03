//
//  SEShape.h
//  Pods
//
//  Created by Danil Tulin on 3/21/16.
//
//

#import <Foundation/Foundation.h>

@interface SEPoint : NSObject

- (instancetype)initWithPoint:(CGPoint)point;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@end

@interface SEShape : NSObject 

- (instancetype)scaledShape:(CGSize)scaleFactor;
- (SEPoint *)objectAtIndexedSubscript:(NSUInteger)idx;

- (void)insertPoint:(SEPoint *)anObject atIndex:(NSUInteger)index;

- (void)drawInContext:(CGContextRef)context;

@end