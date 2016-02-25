//
//  SECornerView.h
//  Pods
//
//  Created by Danil Tulin on 2/25/16.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SECornerViewType) {
	SECornerViewTypeTopLeft = 0,
	SECornerViewTypeTopRight,
	SECornerViewTypeBottomLeft,
	SECornerViewTypeBottomRight
};

@interface SECornerView : UIView

- (instancetype)initWithType:(SECornerViewType)type andRect:(CGRect)rect;
- (instancetype)initWithType:(SECornerViewType)type;

@property (nonatomic, readonly) SECornerViewType type;
@property (nonatomic, readonly) CGRect rect;

@end
