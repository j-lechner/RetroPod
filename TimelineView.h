//
//  TimelineView.h
//  Pod
//
//  Created by Johannes Lechner on 05.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	PlayerStateNormal,
	PlayerStateScrubbing,
	PlayerStateVolume
} PlayerState;

typedef enum {
	PlayerRepeatOff,
	PlayerRepeatOne,
	PlayerRepeatAll
} PlayerRepeatState;

typedef enum {
	PlayerShuffleOff,
	PlayerShuffleOn
} PlayerShuffleState;

@interface TimelineView : UIView {
	PlayerState state;
	double progress;
	
	UILabel *timeElapsedLabel;
	UILabel *timeRemainingLabel;
	
	UIImageView *leftSpeakerImageView;
	UIImageView *rightSpeakerImageView;
}

@property (assign,setter=setState:) PlayerState state;
@property (assign,setter=setProgress:) double progress;

@property (readonly) UILabel *timeElapsedLabel;
@property (readonly) UILabel *timeRemainingLabel;

@end
