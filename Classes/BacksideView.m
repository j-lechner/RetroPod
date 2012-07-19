// Copyright 2009-2010 Johannes Lechner
//
// This file is part of RetroPod.
//
// RetroPod is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// RetroPod is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with RetroPod.  If not, see <http://www.gnu.org/licenses/>.

//
//  BacksideView.m
//  Pod
//
//  Created by Johannes Lechner on 09.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "BacksideView.h"

#import "CaptureSessionManager.h"

@interface BacksideView ()

@property (nonatomic,retain) CaptureSessionManager *captureSessionManager;

@property (assign,readwrite) BOOL showsLiveVideo;

@end

@implementation BacksideView

@synthesize captureSessionManager;

@synthesize delegate;

@synthesize engravingField;
@synthesize mirrorImageView;
@synthesize overlayButton;
@synthesize capacityView;

@synthesize showsLiveVideo;

/**
 Adds live video if a front camera is available
 
 @return BOOL front camera is available
 */
- (BOOL)addLiveVideoLayer
{
	self.captureSessionManager = [[[CaptureSessionManager alloc] init] autorelease];
	
	if(![self.captureSessionManager addVideoInput])
	{
		self.captureSessionManager = nil;
		return NO;
	}

	[self.captureSessionManager addVideoPreviewLayer];
	CGRect layerRect = [[self layer] bounds];
	[[self.captureSessionManager previewLayer] setBounds:layerRect];
	[[self.captureSessionManager previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
																  CGRectGetMidY(layerRect))];
	AVCaptureVideoPreviewLayer *layerPreview = [self.captureSessionManager previewLayer];
	[[self layer] addSublayer:layerPreview];
	
	[[self.captureSessionManager captureSession] startRunning];
	
	return YES;
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
	{
		return nil;
    }
	
	self.userInteractionEnabled = YES;
	self.backgroundColor = [UIColor whiteColor];
	self.opaque = NO;
	
	self.showsLiveVideo = [self addLiveVideoLayer];
	if(!self.showsLiveVideo)
	{
		mirrorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,
																		0.0,
																		frame.size.width,
																		frame.size.height)];
		mirrorImageView.opaque = NO;
		mirrorImageView.backgroundColor = [UIColor clearColor];
		mirrorImageView.contentMode = UIViewContentModeScaleAspectFill;
		//	mirrorImageView.transform = CGAffineTransformIdentity;
		//	mirrorImageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
		[self addSubview:mirrorImageView];
	}
	

	maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,
																  0.0,
																  frame.size.width,
																  frame.size.height)];
	maskImageView.opaque = NO;
	maskImageView.backgroundColor = [UIColor clearColor];
	maskImageView.image = [UIImage imageNamed:@"Mask.png"];
	[self addSubview:maskImageView];
	
	
	engravingField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 
																   30.0, 
																   300.0,
																   80.0)];
	engravingField.borderStyle = UITextBorderStyleNone;
	engravingField.font = [UIFont fontWithName:@"Helvetica" size:20.0];
	engravingField.textColor = [UIColor whiteColor];
	engravingField.textAlignment = UITextAlignmentCenter;
	engravingField.backgroundColor = [UIColor clearColor];
	engravingField.delegate = self;
	engravingField.returnKeyType = UIReturnKeyDone;
	engravingField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
	
	[self addSubview:engravingField];
	
	beaverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,
																	135.0,
																	320.0,
																	106.0)];
	beaverImageView.opaque = NO;
	beaverImageView.backgroundColor = [UIColor clearColor];
	beaverImageView.contentMode = UIViewContentModeScaleAspectFit;
	beaverImageView.image = [UIImage imageNamed:@"Beaver.png"];
	[self addSubview:beaverImageView];
	
	
	copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
															   400.0,
															   320.0,
															   90.0)];
	copyrightLabel.opaque = NO;
	copyrightLabel.backgroundColor = [UIColor clearColor];
	
	NSString *b = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	copyrightLabel.text = [NSString stringWithFormat:@"%@\n%@%@\n%@",
						   @"Simulated by Fudgy Software in Bavaria",
						   @"Model No.: F1000 Version No.: 1.0 Revision No.: ",
						   (b != nil) ? [b substringFromIndex:4] : @"1",
						   @"© 2012 Johannes Lechner"];
	copyrightLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
	copyrightLabel.textColor = [UIColor whiteColor];
	copyrightLabel.textAlignment = UITextAlignmentCenter;
	copyrightLabel.numberOfLines = 4;
	[self addSubview:copyrightLabel];

	retroPodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
															  243.0,
															  320.0,
															  57.0)];
	retroPodLabel.opaque = NO;
	retroPodLabel.backgroundColor = [UIColor clearColor];
	retroPodLabel.text = NSLocalizedString(@"PodName",@"");
	retroPodLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.0];
	retroPodLabel.textColor = [UIColor whiteColor];
	retroPodLabel.textAlignment = UITextAlignmentCenter;
	[self addSubview:retroPodLabel];

	
	overlayButton = [[UIButton alloc] initWithFrame:CGRectMake(106.0,
															   135.0,
															   108.0,
															   97.0)];
	[self addSubview:overlayButton];
	
	capacityView = [[CapacityView alloc] initWithFrame:CGRectMake(124.0,
																  375.0,
																  70.0,
																  38.0)];
	capacityView.opaque = NO;
	capacityView.backgroundColor = [UIColor clearColor];
	capacityView.contentMode = UIViewContentModeRedraw;
	[self addSubview:capacityView];
	
	return self;
}
	
- (void)dealloc
{
	self.captureSessionManager = nil;
	
	[mirrorImageView release];
	[maskImageView release];
	
	[engravingField release];
	[beaverImageView release];
	
	[copyrightLabel release];
	[retroPodLabel release];
	[overlayButton release];
	[capacityView release];
	[super dealloc];
}

- (void)setControlsEnabled:(BOOL)e;
{
	overlayButton.userInteractionEnabled = e;
}

- (BOOL)controlsEnabled;
{
	return overlayButton.userInteractionEnabled;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(overlayButton.userInteractionEnabled)
	{
		[delegate backsideViewWasTouched:self];
	}
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
	[delegate backsideViewDidBeginEditingEngraving:self];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	[delegate backsideViewDidEndEditingEngraving:self];
	[textField resignFirstResponder];
	return NO;
}

@end
