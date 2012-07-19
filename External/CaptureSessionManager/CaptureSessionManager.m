//Adapted from http://www.musicalgeometry.com/?p=1273

#import "CaptureSessionManager.h"

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;

#pragma mark Capture Session Configuration

- (id)init {
	if ((self = [super init])) {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
	}
	return self;
}

//From: http://stackoverflow.com/questions/5886719/what-is-the-front-cameras-deviceuniqueid
-(AVCaptureDevice *)frontFacingCameraIfAvailable
{
	NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	AVCaptureDevice *captureDevice = nil;
	for (AVCaptureDevice *device in videoDevices)
	{
		if (device.position == AVCaptureDevicePositionFront)
		{
			captureDevice = device;
			break;
		}
	}
	
	return captureDevice;
}

- (void)addVideoPreviewLayer {
	[self setPreviewLayer:[[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]] autorelease]];
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	
}

- (BOOL)addVideoInput {
	AVCaptureDevice *videoDevice = [self frontFacingCameraIfAvailable];	
	if (videoDevice) 
	{
		NSError *error;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if (!error) {
			if ([[self captureSession] canAddInput:videoIn])
			{
				[[self captureSession] addInput:videoIn];
				return YES;
			}
			else
			{
				NSLog(@"Couldn't add video input");
				return NO;
			}
		}
		else
		{
			NSLog(@"Couldn't create video input");
			return NO;
		}
	}
	else
	{
		NSLog(@"Couldn't create video capture device");
		return NO;
	}
}

- (void)dealloc {
	
	[[self captureSession] stopRunning];
	
	[previewLayer release], previewLayer = nil;
	[captureSession release], captureSession = nil;
	
	[super dealloc];
}

@end