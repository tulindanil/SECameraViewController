//
//  SEPredscriptionVIew.h
//  Pods
//
//  Created by Danil Tulin on 2/25/16.
//
//

#import <UIKit/UIKit.h>

@interface SEPredscriptionView : UIView

@property (nonatomic, strong) NSString *predscription;

- (void)showPredscriptionLabel:(BOOL)animated;
- (void)hidePredscriptionLabel:(BOOL)animated;

@end
