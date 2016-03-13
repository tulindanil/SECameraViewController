//
//  SECameraViewController.h
//  Pods
//
//  Created by Danil Tulin on 1/26/16.
//
//

@import UIKit;
@import AVFoundation;

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

@end

@protocol SECameraViewControllerDelegate <NSObject>

@optional

- (void)cameraViewController:(SECameraViewController *)cameraViewController
 didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)cameraViewController:(SECameraViewController *)cameraViewController
    didCaptureBGRASampleData:(u_int8_t *)data
					   width:(NSUInteger)width
					  height:(NSUInteger)height;

@required

@end