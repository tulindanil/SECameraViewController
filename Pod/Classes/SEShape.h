//
//  SEShape.h
//  Pods
//
//  Created by Danil Tulin on 3/21/16.
//
//

@import Foundation;

@interface SEShape : NSObject 

+ (instancetype)scaledShape:(CGSize)scaleFactor;

@property (nonatomic) CGPoint topLeft;
@property (nonatomic) CGPoint topRight;
@property (nonatomic) CGPoint bottomLeft;
@property (nonatomic) CGPoint bottomRight;

@end