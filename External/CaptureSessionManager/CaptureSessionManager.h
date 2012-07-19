//Adapted from http://www.musicalgeometry.com/?p=1273

#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface CaptureSessionManager : NSObject {
	
}

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;


- (void)addVideoPreviewLayer;
- (BOOL)addVideoInput;

@end