//
//  PlayerView.m
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "PlayerView.h"


@implementation PlayerView

@synthesize delegate;

@synthesize state;

@synthesize trackNumberLabel;

@synthesize repeatState;
@synthesize shuffleState;

@synthesize titleLabel;
@synthesize artistLabel;
@synthesize albumLabel;

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
		return nil;
    }
	
	state = PlayerStateNormal;
	repeatState = PlayerRepeatOff;
	shuffleState = PlayerShuffleOff;
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	
	trackNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0,
														   0.0,
														   (frame.size.width / 2.0),
														   20.0)];
	trackNumberLabel.opaque = NO;
	trackNumberLabel.backgroundColor = [UIColor clearColor];
	trackNumberLabel.textAlignment = UITextAlignmentLeft;
	trackNumberLabel.font = [UIFont boldSystemFontOfSize:12.0];
	[self addSubview:trackNumberLabel];
	
	repeatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 50.0,
																	3.0,
																	20.0,
																	20.0)];
	repeatImageView.opaque = NO;
	repeatImageView.backgroundColor = [UIColor clearColor];
	[self addSubview:repeatImageView];

	shuffleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 25.0,
																	3.0,
																	20.0,
																	20.0)];
	shuffleImageView.opaque = NO;
	shuffleImageView.backgroundColor = [UIColor clearColor];
	[self addSubview:shuffleImageView];
	
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
														   20.0,
														   frame.size.width,
														   23.0)];
	titleLabel.opaque = NO;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
	[self addSubview:titleLabel];
	
	artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
														   43.0,
														   frame.size.width,
														   23.0)];
	artistLabel.opaque = NO;
	artistLabel.backgroundColor = [UIColor clearColor];
	artistLabel.textAlignment = UITextAlignmentCenter;
	artistLabel.font = [UIFont boldSystemFontOfSize:15.0];
	[self addSubview:artistLabel];
	

	albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
														   66.0,
														   frame.size.width,
														   23.0)];
	albumLabel.opaque = NO;
	albumLabel.backgroundColor = [UIColor clearColor];
	albumLabel.textAlignment = UITextAlignmentCenter;
	albumLabel.font = [UIFont boldSystemFontOfSize:15.0];
	[self addSubview:albumLabel];
	
	firstTimelineView = [[TimelineView alloc] initWithFrame:CGRectMake(0.0, 0.0,
																	   frame.size.width,
																	   frame.size.height)];
	firstTimelineView.opaque = NO;
	[self addSubview:firstTimelineView];
	
	secondTimelineView = [[TimelineView alloc] initWithFrame:CGRectMake(0.0, 0.0,
																		frame.size.width,
																		frame.size.height)];
	secondTimelineView.opaque = NO;
	secondTimelineView.hidden = YES;
	[self addSubview:secondTimelineView];
	
    return self;
}

- (void)dealloc {
	[trackNumberLabel release];
	
	[repeatImageView release];
	[shuffleImageView release];
	
	[titleLabel release];
	[artistLabel release];
	[albumLabel release];
	
	[firstTimelineView release];
	[secondTimelineView release];

	[super dealloc];
}

- (PlayerState)state
{
	return state;
}

- (void)setState:(PlayerState)s;
{
	PlayerState previousState = state;
	state = s;
	
	if(previousState == state)
	{
		return;
	}
	
	CGRect outsideLeftFrame = self.bounds;
	CGRect outsideRightFrame = self.bounds;
	outsideLeftFrame.origin.x = -outsideLeftFrame.size.width;
	outsideRightFrame.origin.x = outsideRightFrame.size.width;

	if(PlayerStateNormal == previousState)
	{
		secondTimelineView.frame = outsideRightFrame;
		secondTimelineView.hidden = NO;
	}
	else
	{
		firstTimelineView.frame = outsideLeftFrame;
		firstTimelineView.hidden = NO;
	}
	
	[delegate viewWillAnimate:self];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.3];
	
	if(PlayerStateNormal == previousState)
	{
		secondTimelineView.state = state;
		firstTimelineView.frame = outsideLeftFrame;
		secondTimelineView.frame = self.bounds;
	}
	else
	{
		firstTimelineView.frame = self.bounds;
		secondTimelineView.frame = outsideRightFrame;
	}

	[UIView commitAnimations];
}

- (PlayerRepeatState)repeatState
{
	return repeatState;
}

- (void)setRepeatState:(PlayerRepeatState)s;
{
	if(PlayerRepeatOne == s)
	{
		repeatImageView.image = [UIImage imageNamed:@"Repeat-One.png"];
	}
	else if(PlayerRepeatAll == s)
	{
		repeatImageView.image = [UIImage imageNamed:@"Repeat-All.png"];
	}
	else
	{
		repeatImageView.image = nil;
	}
	repeatState = s;
}

- (PlayerShuffleState)shuffleState
{
	return shuffleState;
}

- (void)setShuffleState:(PlayerShuffleState)s;
{
	if(PlayerShuffleOn == s)
	{
		shuffleImageView.image = [UIImage imageNamed:@"Shuffle.png"];
	}
	else
	{
		shuffleImageView.image = nil;
	}
	shuffleState = s;
}

- (void)animationDidStop:(NSString *)animationID 
				finished:(NSNumber *)finished 
				 context:(void *)context;
{
	if(PlayerStateNormal == state)
	{
		firstTimelineView.hidden = NO;
		secondTimelineView.hidden = YES;
	}
	else
	{
		firstTimelineView.hidden = YES;
		secondTimelineView.hidden = NO;
	}

	[delegate viewDidAnimate:self];
}

- (void)setProgress:(double)p;
{
	firstTimelineView.progress = p;
	
	if(PlayerStateScrubbing == secondTimelineView.state)
	{
		secondTimelineView.progress = p;
	}
}

- (void)setVolume:(double)v;
{
	if(PlayerStateVolume == secondTimelineView.state)
	{
		secondTimelineView.progress = v;
	}
}

- (double)progress;
{
	return -1.0;
}

- (double)volume;
{
	return -1.0;
}

- (void)setTimeElapsed:(NSString *)time;
{
	firstTimelineView.timeElapsedLabel.text = time;
	secondTimelineView.timeElapsedLabel.text = time;
}

- (void)setTimeRemaining:(NSString *)time;
{
	firstTimelineView.timeRemainingLabel.text = time;
	secondTimelineView.timeRemainingLabel.text = time;
}

- (NSString *)timeElapsed;
{
	return nil;
}

- (NSString *)timeRemaining;
{
	return nil;
}

- (void)reset;
{
	firstTimelineView.frame = self.bounds;
	firstTimelineView.hidden = NO;
	secondTimelineView.hidden = YES;
	
	firstTimelineView.progress = 0.0;
	secondTimelineView.progress = 0.0;
	
	state = PlayerStateNormal;
	repeatState = PlayerRepeatOff;
	shuffleState = PlayerShuffleOff;
}	

@end
