//
//  SEShape.h
//  Pods
//
//  Created by Danil Tulin on 3/21/16.
//
//

@import Foundation;

@interface SEPoint : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@end

@interface SEShape : NSObject 

- (instancetype)scaledShape:(CGSize)scaleFactor;

- (SEPoint *)objectAtIndexedSubscript:(NSUInteger)idx;

@end