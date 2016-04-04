//
//  SEShapeView.h
//  Pods
//
//  Created by Danil Tulin on 4/2/16.
//
//

#import <UIKit/UIKit.h>

#import "SEShape.h"

@interface SEShapeView : UIView

- (void)addShape:(SEShape *)shape
	   withColor:(UIColor *)color;
- (void)clearShapes;

@end
