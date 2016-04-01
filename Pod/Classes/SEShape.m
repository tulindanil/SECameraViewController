//
//  SEShape.m
//  Pods
//
//  Created by Danil Tulin on 3/21/16.
//
//

#import "SEShape.h"

@interface SEShape ()

@end

@implementation SEShape

+ (instancetype)scaledShape:(CGSize)scaleFactor {
	SEShape *shape = [[SEShape alloc] init];
	
	CGFloat widthFactor = scaleFactor.width;
	CGFloat heightFactor = scaleFactor.height;
	
	return shape;
}

+ (CGPoint)scalePoint:(CGPoint)point withScale:(CGSize)scale {
	CGPoint newPoint = {};
	return newPoint;
}

@end
