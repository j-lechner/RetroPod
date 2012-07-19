//
//  TimelineView.m
//  Pod
//
//  Created by Johannes Lechner on 05.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "TimelineView.h"


@implementation TimelineView

@synthesize state;
@synthesize progress;

@synthesize timeElapsedLabel;
@synthesize timeRemainingLabel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		timeElapsedLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0,
																	 frame.size.height - 25.0,
																	 (frame.size.width / 2.0),
																	 25.0)];
		timeElapsedLabel.opaque = NO;
		timeElapsedLabel.backgroundColor = [UIColor clearColor];
		timeElapsedLabel.textAlignment = UITextAlignmentLeft;
		timeElapsedLabel.font = [UIFont boldSystemFontOfSize:15.0];
		[self addSubview:timeElapsedLabel];
		
		timeRemainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - (frame.size.width / 2.0) - 12.0,
																	   frame.size.height - 25.0,
																	   (frame.size.width / 2.0),
																	   25.0)];
		timeRemainingLabel.opaque = NO;
		timeRemainingLabel.backgroundColor = [UIColor clearColor];
		timeRemainingLabel.textAlignment = UITextAlignmentRight;
		timeRemainingLabel.font = [UIFont boldSystemFontOfSize:15.0];
		[self addSubview:timeRemainingLabel];
		
		leftSpeakerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Speaker.png"]];
		leftSpeakerImageView.backgroundColor = [UIColor clearColor];
		leftSpeakerImageView.clipsToBounds = YES;
		leftSpeakerImageView.contentMode = UIViewContentModeLeft;
		CGRect smallFrame = leftSpeakerImageView.frame;
		smallFrame.size.width = 8.0;
		leftSpeakerImageView.frame = smallFrame;
		leftSpeakerImageView.center = CGPointMake(16.0,109.0);
		leftSpeakerImageView.hidden = YES;
		[self addSubview:leftSpeakerImageView];
		
		rightSpeakerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Speaker.png"]];;
		rightSpeakerImageView.backgroundColor = [UIColor clearColor];
		rightSpeakerImageView.clipsToBounds = YES;
		rightSpeakerImageView.center = CGPointMake(185.0,109.0);
		rightSpeakerImageView.hidden = YES;
		[self addSubview:rightSpeakerImageView];
    }
    return self;
}

- (void)dealloc 
{
	[timeElapsedLabel release];
	[timeRemainingLabel release];
	
	[leftSpeakerImageView release],
	[rightSpeakerImageView release];
    [super dealloc];
}

- (void)drawSpeakerInContext:(CGContextRef)context 
				  atLocation:(CGPoint)location
				   withWaves:(BOOL)w;
{
	CGContextSaveGState(context);
	
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextSetLineWidth(context, 1.0);

	if(w)
	{
		CGContextSaveGState(context);
		
		CGContextBeginPath(context);

		CGContextMoveToPoint(context, location.x, location.y-10.0);
		CGContextAddLineToPoint(context, location.x, location.y+7.0+10.0);
		CGContextAddLineToPoint(context, location.x + 5.0 + 15.0 + 5.0, location.y+7.0+10.0);
		CGContextAddLineToPoint(context, location.x + 5.0 + 15.0 + 5.0, location.y+7.0+10.0);

		
		CGContextAddLineToPoint(context, location.x, location.y+7.0);
		CGContextAddLineToPoint(context, location.x+4.0, location.y+7.0);
		CGContextAddLineToPoint(context, location.x+10.0, location.y+12.0);
		CGContextAddLineToPoint(context, location.x+10.0, location.y-4.0);
		CGContextAddLineToPoint(context, location.x+4.0, location.y);
		
		CGContextClosePath(context);

		CGContextFillPath(context);
		
		CGContextStrokeEllipseInRect(context, CGRectMake(location.x + 5.0 + 5.0, 
														 location.y + 4.0 - (05.0/2.0), 
														 5.0, 
														 5.0));
		
		CGContextStrokeEllipseInRect(context, CGRectMake(location.x + 5.0 + 2.5, 
														 location.y + 4.0 - (10.0/2.0), 
														 10.0, 
														 10.0));
		
		CGContextStrokeEllipseInRect(context, CGRectMake(location.x + 5.0 + 0.0, 
														 location.y + 4.0 - (15.0/2.0), 
														 15.0, 
														 15.0));

		CGContextRestoreGState(context);
	}
	
	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, location.x, location.y);
	CGContextAddLineToPoint(context, location.x, location.y+7.0);
	CGContextAddLineToPoint(context, location.x+4.0, location.y+7.0);
	CGContextAddLineToPoint(context, location.x+10.0, location.y+12.0);
	CGContextAddLineToPoint(context, location.x+10.0, location.y-4.0);
	CGContextAddLineToPoint(context, location.x+4.0, location.y);
	
	CGContextClosePath(context);
	CGContextFillPath(context);
	
	CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
	rect = CGRectMake(10.0,
					  rect.size.height - 25.0 - 12.0, 
					  rect.size.width - 20.0,
					  12.0);
	
	if(PlayerStateVolume == state)
	{
		rect.size.width -= 40.0;
		rect.origin.x += 17.0;
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat radius = 10.0;
	CGFloat fw = CGRectGetWidth(rect) / radius;
	CGFloat fh = CGRectGetHeight(rect) / radius;
	
	CGContextSaveGState(context);
	
	if(PlayerStateNormal == state)
	{
		//Create clipping mask for fill
		CGContextSaveGState(context);
		CGContextBeginPath(context);
		
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextScaleCTM(context, radius, radius);
		
		CGContextMoveToPoint(context, fw, fh/2.0);
		CGContextAddArcToPoint(context, fw, fh, fw/2.0, fh, 0.5);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2.0, 0.5);
		CGContextAddArcToPoint(context, 0, 0, fw/2.0, 0, 0.5);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2.0, 0.5);
		
		CGContextClosePath(context);
		CGContextRestoreGState(context);
		
		CGContextEOClip(context);
	}

	if(PlayerStateScrubbing == state)
	{
		CGContextSaveGState(context);
		
		//Create clipping mask for scrubber
		CGContextSaveGState(context);
		CGContextBeginPath(context);
		
		CGContextSetLineWidth(context, 1.5);
		CGContextAddRect(context, rect);
		
		CGContextRestoreGState(context);
		
		CGContextEOClip(context);
		
		CGContextBeginPath(context);
		
		CGContextMoveToPoint(context,
							 rect.origin.x + (progress * rect.size.width),
							 rect.origin.y);
		
		CGContextAddLineToPoint(context,
								rect.origin.x + (progress * rect.size.width) + (rect.size.height/2.0),
								(rect.origin.y + (rect.size.height/2.0)));
		
		CGContextAddLineToPoint(context,
								rect.origin.x + (progress * rect.size.width),
								rect.origin.y + rect.size.height);
		
		CGContextAddLineToPoint(context,
								rect.origin.x + (progress * rect.size.width) - (rect.size.height/2.0),
								(rect.origin.y + (rect.size.height/2.0)));
		
		CGContextAddLineToPoint(context,
								rect.origin.x + (progress * rect.size.width),
								rect.origin.y);
		
		CGContextSetRGBFillColor(context, 0.15, 0.15, 0.15, 1.0);
		CGContextFillPath(context);
		
		CGContextRestoreGState(context);
	}
	else
	{
		CGRect fillRect = rect;
		fillRect.size.width = progress * rect.size.width;

		CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
		CGContextFillRect(context,fillRect);
	}

	CGContextRestoreGState(context);
	
	if(PlayerStateNormal == state)
	{
		//Stroke rect with rounded edges
		CGContextSaveGState(context);
		CGContextBeginPath(context);
		
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextScaleCTM(context, radius, radius);
		
		CGContextMoveToPoint(context, fw, fh/2.0);
		CGContextAddArcToPoint(context, fw, fh, fw/2.0, fh, 0.5);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2.0, 0.5);
		CGContextAddArcToPoint(context, 0, 0, fw/2.0, 0, 0.5);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2.0, 0.5);
		
		CGContextClosePath(context);
		CGContextRestoreGState(context);
		
		CGContextSetLineWidth(context, 1.5);
		CGContextSetRGBStrokeColor(context, 0.15, 0.15, 0.15, 1.0);
		CGContextStrokePath(context);
	}
	else
	{
		//Stroke normal rect
		CGContextSetLineWidth(context, 1.5);
		CGContextSetRGBStrokeColor(context, 0.15, 0.15, 0.15, 1.0);
		CGContextStrokeRect(context, rect);
	}
}

- (PlayerState)state
{
	return state;
}

- (void)setState:(PlayerState)s;
{
	state = s;
	
	switch (state) {
		case PlayerStateNormal:
		case PlayerStateScrubbing:
			timeElapsedLabel.hidden = NO;
			timeRemainingLabel.hidden = NO;
			leftSpeakerImageView.hidden = YES;
			rightSpeakerImageView.hidden = YES;
			break;
		case PlayerStateVolume:
			timeElapsedLabel.hidden = YES;
			timeRemainingLabel.hidden = YES;
			leftSpeakerImageView.hidden = NO;
			rightSpeakerImageView.hidden = NO;
			break;
	}
	
	[self setNeedsDisplay];
}

- (double)progress
{
	return progress;
}

- (void)setProgress:(double)p;
{
	if(p < 0.0)
	{
		progress = 0.0;
	}
	else if(p > 1.0)
	{
		progress = 1.0;
	}
	else
	{
		progress = p;
	}
	
	[self setNeedsDisplay];
}

@end
