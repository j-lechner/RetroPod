//
//  BackSideController.m
//  Pod
//
//  Created by Johannes Lechner on 04.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "BackSideController.h"

#import "Settings.h"

#include <sys/param.h>
#include <sys/mount.h>

@implementation BackSideController

- (id)initWithParentController:(UIViewController *)c 
				 forParentView:(UIView *)p 
				 andViewToFlip:(UIView *)v;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	parentController = c;
	parentView = p;
	viewToFlip = v;
	
	backsideView = [[BacksideView alloc] initWithFrame:parentView.frame];
	backsideView.delegate = self;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *mirrorImageFile = [documentsPath stringByAppendingPathComponent:@"mirror.png"];
	
	UIImage *mirrorImage = [UIImage imageWithContentsOfFile:mirrorImageFile];
	if(mirrorImage != nil)
	{
		backsideView.mirrorImageView.image = mirrorImage;
	}
	else
	{
		backsideView.mirrorImageView.image = [UIImage imageNamed:@"Mirror.png"];
	}
	
	struct statfs tStats;
	statfs([[paths lastObject] cString], &tStats);
	float bytes = (float)(tStats.f_blocks * tStats.f_bsize);
	float megabytes = (bytes / 1000.0 / 1000.0);
	
	int minDiffIndex = 0;
	double minDiff = 0.0;
	
	for(int i=1;i<16;i++)
	{
		double currDiff = abs(megabytes - (pow(2, i) * 1000.0));
		
		if(0 == minDiffIndex)
		{
			minDiff = fabs(currDiff);
			minDiffIndex = 1;
		}
		else
		{
			if(fabs(currDiff) <= minDiff)
			{
				minDiff = fabs(currDiff);
				minDiffIndex = i;
			}
		}
	}
	
	backsideView.capacityView.capacity = [NSString stringWithFormat:@"%dGB",
										  (int)pow(2,minDiffIndex)];
	
	[backsideView.overlayButton addTarget:self action:@selector(takePicture:) 
							forControlEvents:UIControlEventTouchDown];
	
	return self;
}

- (void)dealloc;
{
	[backsideView.overlayButton removeTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchDown];
	
	[backsideView release];
	[timeoutTimer invalidate];
	timeoutTimer = nil;
	[super dealloc];
}

- (void)activate;
{
	[timeoutTimer invalidate];
	timeoutTimer = nil;
	
	backsideView.engravingField.text = [Settings currentSettings].engravingText;
	
	activationFinished = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(flipDidStop:finished:context:)];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
						   forView:parentView 
							 cache:YES];
	
	backsideView.hidden = NO;
	[viewToFlip removeFromSuperview];
	[parentView addSubview:backsideView];
	
	[UIView commitAnimations];
}

- (void)flipDidStop:(NSString *)animationID 
		   finished:(NSNumber *)finished 
			context:(void *)context;
{
	activationFinished = YES;
	timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 
													target:self 
												  selector:@selector(didTimeout:) 
												  userInfo:nil 
												   repeats:NO];
}	

- (void)didTimeout:(NSTimer *)t;
{
	timeoutTimer = nil;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
						   forView:parentView 
							 cache:YES];
	
	backsideView.hidden = YES;
	[backsideView removeFromSuperview];
	[parentView addSubview:viewToFlip];
	
	[UIView commitAnimations];
}

- (IBAction)takePicture:(id)sender;
{
	if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		return;
	}
	
	[timeoutTimer invalidate];
	timeoutTimer = nil;
	
	UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
	pickerController.allowsEditing = NO;
	pickerController.delegate = self;
	pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

	[parentController presentModalViewController:pickerController animated:YES];
	[pickerController autorelease];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
	UIImage *origImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	NSAssert(nil != origImage,@"");

	CGImageRef mirrorImageRef = [origImage CGImage];
	CGColorSpaceRef colorspace = CGImageGetColorSpace(mirrorImageRef);
	
	CGContextRef context = CGBitmapContextCreate(NULL,
												 320.0,
												 480.0,
												 CGImageGetBitsPerComponent(mirrorImageRef),
												 CGImageGetBytesPerRow(mirrorImageRef),
												 colorspace,
												 CGImageGetAlphaInfo(mirrorImageRef));
	
	if(NULL != context)
	{
		if(UIImageOrientationUp == origImage.imageOrientation ||
			UIImageOrientationDown == origImage.imageOrientation)
		{
			CGContextConcatCTM(context, CGAffineTransformMakeTranslation(0.0,0.0));
			CGContextConcatCTM(context, CGAffineTransformMakeScale(-1.0, 1.0));
		}
		else
		{
			CGContextConcatCTM(context, CGAffineTransformMakeTranslation(320.0,480.0));
			CGContextConcatCTM(context, CGAffineTransformMakeScale(1.0, -1.0));
		}
		CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI_2));
		
		float widthRatio = 480.0/CGImageGetWidth(mirrorImageRef);
		float heightWithWidth480 = widthRatio * CGImageGetHeight(mirrorImageRef);

		float heightRatio = 320.0/CGImageGetHeight(mirrorImageRef);
		float widthWithHeight320 = heightRatio * CGImageGetWidth(mirrorImageRef);
		
		CGRect imageRect = CGRectZero;
		
		if(heightWithWidth480 >= 320.0)
		{
			imageRect = CGRectMake(0.0,
								   (320.0-heightWithWidth480)/2.0,
								   480.0,
								   heightWithWidth480);
		}
		else
		{
			imageRect = CGRectMake((480.0 - widthWithHeight320)/2.0,
								   0.0,
								   widthWithHeight320,
								   320.0);
		}
		
		CGContextDrawImage(context, imageRect, mirrorImageRef);

		CGImageRef imgRef = CGBitmapContextCreateImage(context);
		
		if(NULL != imgRef)
		{
			UIImage *pickedImage = [UIImage imageWithCGImage:imgRef];
			
			backsideView.mirrorImageView.image = pickedImage;
			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
			NSString *documentsPath = [paths objectAtIndex:0];
			NSString *mirrorImageFile = [documentsPath stringByAppendingPathComponent:@"mirror.png"];
			
			[[NSFileManager defaultManager] removeItemAtPath:mirrorImageFile error:nil];
			NSData *mirrorImageData = UIImagePNGRepresentation(pickedImage);
			if(![mirrorImageData writeToFile:mirrorImageFile atomically:YES])
			{
				NSLog(@"Error writing mirror image to disk");
			}
			
			CGImageRelease(imgRef);
		}
		
		CGContextRelease(context);
	}

	[picker dismissModalViewControllerAnimated:YES];

	timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 
													target:self 
												  selector:@selector(didTimeout:) 
												  userInfo:nil 
												   repeats:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
	[picker dismissModalViewControllerAnimated:YES];
	
	timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 
													target:self 
												  selector:@selector(didTimeout:) 
												  userInfo:nil 
												   repeats:NO];
}


#pragma mark -
#pragma mark BacksideViewDelegate

- (void)backsideViewWasTouched:(BacksideView *)view;
{
	if(activationFinished)
	{
		[timeoutTimer invalidate];
		timeoutTimer = nil;
		[self didTimeout:nil];
	}
}

- (void)backsideViewDidBeginEditingEngraving:(BacksideView *)view;
{
	view.controlsEnabled = NO;
	[timeoutTimer invalidate];
	timeoutTimer = nil;
}

- (void)backsideViewDidEndEditingEngraving:(BacksideView *)view;
{
	[Settings currentSettings].engravingText = backsideView.engravingField.text;
	view.controlsEnabled = YES;
	timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 
													target:self 
												  selector:@selector(didTimeout:) 
												  userInfo:nil 
												   repeats:NO];
}

@end
