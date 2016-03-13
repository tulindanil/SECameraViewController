//
//  SEVision.h
//  Pods
//
//  Created by Danil Tulin on 3/13/16.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol SEVisionDelegate;
@interface SEVision : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak, nullable) id<SEVisionDelegate> delegate;

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *previewLayer;

- (void)startPreview;
- (void)stopPreview;

@end

@protocol SEVisionDelegate <NSObject>

@optional

// session

- (void)visionSessionWillStart:(SEVision *)vision;
- (void)visionSessionDidStart:(SEVision *)vision;
- (void)visionSessionDidStop:(SEVision *)vision;

- (void)visionSessionWasInterrupted:(SEVision *)vision;
- (void)visionSessionInterruptionEnded:(SEVision *)vision;

// focus / exposure

- (void)visionWillStartFocus:(SEVision *)vision;
- (void)visionDidStopFocus:(SEVision *)vision;

- (void)visionWillChangeExposure:(SEVision *)vision;
- (void)visionDidChangeExposure:(SEVision *)vision;

- (void)visionDidChangeFlashMode:(SEVision *)vision; // flash or torch was changed

// preview

- (void)visionSessionDidStartPreview:(SEVision *)vision;
- (void)visionSessionDidStopPreview:(SEVision *)vision;


// video capture progress

- (void)vision:(SEVision *)vision didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end