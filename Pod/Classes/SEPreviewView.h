//
//  SEPreviewView.h
//  Pods
//
//  Created by Danil Tulin on 2/25/16.
//
//

#import <UIKit/UIKit.h>
#import "SEShape.h"
#import "SEPredscriptionView.h"

@interface SEPreviewView : UIView

@property (nonatomic, readonly) SEPredscriptionView *predscriptionView;

- (void)addShape:(SEShape *)shape;
- (void)clearShapes;

@end
