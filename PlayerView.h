//
//  PlayerView.h
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentView.h"
#import "TimelineView.h"

@interface PlayerView : ContentView {
	id<AnimationStatusDelegate> delegate;
	UILabel *trackNumberLabel;
	
	UIImageView *repeatImageView;
	UIImageView *shuffleImageView;
	
	UILabel *titleLabel;
	UILabel *artistLabel;
	UILabel *albumLabel;
	
	PlayerState state;
	PlayerRepeatState repeatState;
	PlayerShuffleState shuffleState;
	
	TimelineView *firstTimelineView;
	TimelineView *secondTimelineView;
}

@property (assign) id<AnimationStatusDelegate> delegate;

@property (assign,setter=setState:) PlayerState state;
@property (assign,setter=setRepeatState:) PlayerRepeatState repeatState;
@property (assign,setter=setShuffleState:) PlayerShuffleState shuffleState;
@property (assign,setter=setProgress:,getter=progress) double progress;
@property (assign,setter=setVolume:,getter=volume) double volume;

@property (readonly) UILabel *trackNumberLabel;

@property (readonly) UILabel *titleLabel;
@property (readonly) UILabel *artistLabel;
@property (readonly) UILabel *albumLabel;

@property (assign,setter=setTimeElapsed:,getter=timeElapsed) NSString *timeElapsed;
@property (assign,setter=setTimeRemaining:,getter=timeRemaining) NSString *timeRemaining;

- (void)reset;

@end
