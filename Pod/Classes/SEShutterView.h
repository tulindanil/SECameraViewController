//
//  SEShutterView.h
//  Pods
//
//  Created by Danil Tulin on 2/23/16.
//
//

#import <UIKit/UIKit.h>

@interface SEShutterView : UIView

@property (nonatomic, readonly) BOOL isOpen;

- (void)open;
- (void)close;

- (void)openWithCompletion:(void (^)())block;
- (void)closeWithCompletion:(void (^)())block;

- (void)openWithDuration:(CGFloat)duration withCompletion:(void (^)())block;
- (void)closeWithDuration:(CGFloat)duration withCompletion:(void (^)())block;

@end
