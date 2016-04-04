//
//  SECameraViewController.h
//  Pods
//
//  Created by Danil Tulin on 1/26/16.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "SEShape.h"
#import "SEEngineProtocol.h"

typedef NS_ENUM(NSInteger, SEOutputFormat) {
	SEOutputFormatSquare, // 1:1
	SEOutputFormatWidescreen, // 16:9
};

@protocol SECameraViewControllerDelegate;
@interface SECameraViewController : UIViewController

- (instancetype)initWithDelegate:(id<SECameraViewControllerDelegate>)delegate;
@property (nonatomic, weak) id<SECameraViewControllerDelegate> delegate;

@property (nonatomic) SEOutputFormat outputFormat;
@property (nonatomic, getter=isFlashEnabled) BOOL flashEnabled;

@property (nonatomic, weak) id<EngineProtocol> engine;

- (void)addShape:(SEShape *)shape;
- (void)clearShapes;

@property (nonatomic) NSString *label;

- (void)showLabel;
- (void)hideLabel;

@property (nonatomic) UIColor *defaultPrimaryColor;
@property (nonatomic) UIColor *darkPrimaryColor;
@property (nonatomic) UIColor *accentColor;

@end

@protocol SECameraViewControllerDelegate <NSObject>

@optional

- (void)cameraViewControllerDidTapCloseButton:
	(SECameraViewController *)cameraViewController;

- (void)cameraViewController:(SECameraViewController *)cameraViewController
 didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)cameraViewController:(SECameraViewController *)cameraViewController
    didCaptureBGRASampleData:(NSData *)data
					   width:(NSUInteger)width
					  height:(NSUInteger)height;

@required

@end