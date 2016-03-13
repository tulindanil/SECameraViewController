//
//  SEVision.m
//  Pods
//
//  Created by Danil Tulin on 3/13/16.
//
//

#import "SEVision.h"

@interface SEVision () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) AVCaptureDeviceInput *rearCameraInput;
@property (nonatomic) AVCaptureDevice *rearCamera;

@property (nonatomic, readwrite) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) AVCaptureSession *captureSession;

@property (nonatomic) AVCaptureVideoDataOutput *captureVideoDataOutput;

@property (nonatomic) dispatch_queue_t captureVideoQueue;
@property (nonatomic) dispatch_queue_t visionQueue;

@property (nonatomic) BOOL isConnectionsInitialized;

@end

@implementation SEVision

#pragma mark - Singletone

+ (SEVision *)sharedInstance {
	static SEVision *singleton = nil;
	static dispatch_once_t once = 0;
	dispatch_once(&once, ^{
		singleton = [[SEVision alloc] init];
	});
	return singleton;
}

#pragma marl - start and stop

- (void)startPreview {
	[self enqueueBlockInVisionQueue:^{
		if (!self.isConnectionsInitialized) {
			[self initializeConnections];
		}
		
		[self.captureSession startRunning];
		[self enqueueBlockInMainQueue:^{
			if ([self.delegate respondsToSelector:@selector(visionSessionDidStartPreview:)])
				[self.delegate visionSessionDidStartPreview:self];
		}];
	}];
}

- (void)initializeConnections {
	self.isConnectionsInitialized = YES;
	if ([self.captureSession canAddInput:self.rearCameraInput])
		[self.captureSession addInput:self.rearCameraInput];
	
	if ([self.captureSession canAddOutput:self.captureVideoDataOutput] &&
		[self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
		[self.captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
		[self.captureSession addOutput:self.captureVideoDataOutput];
	}
}

- (void)stopPreview {
	[self enqueueBlockInVisionQueue:^{
		[self.captureSession stopRunning];
		[self executeBlockInMainQueue:^{
			if ([self.delegate respondsToSelector:@selector(visionSessionDidStopPreview:)]) {
				[self.delegate visionSessionDidStopPreview:self];
			}
		}];
	}];
}

#pragma mark - Session

- (AVCaptureSession *)captureSession
{
	if (!_captureSession) {
		_captureSession = [[AVCaptureSession alloc] init];
	}
	return _captureSession;
}

- (AVCaptureDevice *)rearCamera
{
	if (!_rearCamera) {
		_rearCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		[_rearCamera lockForConfiguration:nil];
		[_rearCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
		[_rearCamera unlockForConfiguration];
	}
	return _rearCamera;
}

- (AVCaptureDeviceInput *)rearCameraInput
{
	if (!_rearCameraInput) {
		_rearCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.rearCamera error:nil];
	}
	return _rearCameraInput;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
	if (!_previewLayer) {
		_previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
		_previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	}
	return _previewLayer;
}

- (AVCaptureVideoDataOutput *)captureVideoDataOutput {
	if (!_captureVideoDataOutput) {
		_captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
		_captureVideoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]};
		[_captureVideoDataOutput setSampleBufferDelegate:self queue:self.captureVideoQueue];
	}
	return _captureVideoDataOutput;
}

#pragma mark - AVCaptureVideoDataOutputDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
	   fromConnection:(AVCaptureConnection *)connection {
	if ([self.delegate respondsToSelector:@selector(vision:didCaptureVideoSampleBuffer:)]) {
		[self.delegate vision:self didCaptureVideoSampleBuffer:sampleBuffer];
	}
}

#pragma mark - Grand Central Dispatch

- (dispatch_queue_t)visionQueue {
	if (!_visionQueue) {
		_visionQueue = dispatch_queue_create("com.smartengines.vision_queue", 0);
	}
	return _visionQueue;
}

- (dispatch_queue_t)captureVideoQueue {
	if (!_captureVideoQueue) {
		_captureVideoQueue = dispatch_queue_create("com.smartengines.capture_video_queue", 0);
	}
	return _captureVideoQueue;
}

- (void)enqueueBlockInVisionQueue:(void (^)(void))block {
	if (block != nil) {
		dispatch_async(self.visionQueue, block);
	}
}

- (void)enqueueBlockInMainQueue:(void (^)(void))block {
	if (block != nil) {
		dispatch_async(dispatch_get_main_queue(), block);
	}
}

- (void)executeBlockInMainQueue:(void (^)(void))block {
	if (block != nil) {
		dispatch_sync(dispatch_get_main_queue(), block);
	}
}

@end
