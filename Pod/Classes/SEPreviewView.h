//
//  SEPreviewView.h
//  Pods
//
//  Created by Danil Tulin on 2/25/16.
//
//

#import <UIKit/UIKit.h>

@interface SEPreviewView : UIView

@property (nonatomic) NSString *predscription;

- (void)showPredscriptionLabel:(BOOL)animated;
- (void)hidePredscriptionLabel:(BOOL)animated;

- (void)rotatePredscriptionLabelForOrientation:(UIDeviceOrientation)orientation;

@end
