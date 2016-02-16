//
//  SECameraViewController.h
//  Pods
//
//  Created by Danil Tulin on 1/26/16.
//
//

@import UIKit;
@import AVFoundation;

@protocol SECameraViewControllerDelegate;
@interface SECameraViewController : UIViewController

- (instancetype)initWithDelegate:(id<SECameraViewControllerDelegate>)delegate;
@property (nonatomic, weak) id<SECameraViewControllerDelegate> delegate;

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *previewLayer;

@end

@protocol SECameraViewControllerDelegate <NSObject>

@optional

- (void)cameraViewController:(SECameraViewController *)cameraViewController
 didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@required

@end