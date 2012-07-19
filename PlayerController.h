//
//  PlayerController.h
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "PodController.h"
#import "PlayerView.h"
#import "StatusView.h"

@protocol PlayerControllerDelegate;

@interface PlayerController : PodController {
	id<PlayerControllerDelegate> delegate;
	
	MPMusicPlayerController *musicPlayer;
	
	float volume;
	NSTimeInterval lastScrollTimestamp;
	BOOL isSettingVolume;
	BOOL isDisplayingVolume;
	BOOL userChangedVolume;
	
	BOOL isScrubbing;
	NSTimeInterval scrubberTimeElapsed;
	NSTimer *scrubbingTimer;
	
	NSTimer *timelineUpdateTimer;
	NSTimeInterval timeElapsed;
	NSTimeInterval totalTime;
	
	MPMediaItemCollection *currentCollection;
	NSArray *currentCollectionItems;

	StatusView *statusView;
	
	NSTimer *volumeDisplayingTimer;
	NSTimer *scrubberDisplayingTimer;
	
	NSTimer *seekingTriggerTimer;
	ScrollWheelButton pressedButton;
	BOOL isSeeking;
	
	BOOL playAllSongsShuffled;
	MPMusicShuffleMode modeBeforePlayAllShuffledSongs;
}

@property (assign) id<PlayerControllerDelegate> delegate;

@property (assign,setter=setStatusView:) StatusView *statusView;
@property (readonly,getter=playing) BOOL playing;
@property (readonly,getter=stopped) BOOL stopped;

- (id)initForView:(PlayerView *)view;

- (void)skipToPrev;
- (void)skipToStart;
- (void)skipToNext;
- (void)playPauseToogle;

- (void)playItem:(MPMediaItem *)i inCollection:(MPMediaItemCollection *)c;
- (void)playAllSongsShuffled;

@end

@protocol PlayerControllerDelegate

- (void)playerControllerDidStartPlayback:(PlayerController *)c;
- (void)playerControllerDidStopPlayback:(PlayerController *)c;
- (void)playerController:(PlayerController *)c didChangeCollection:(MPMediaItemCollection *)col;
- (void)playerController:(PlayerController *)c didChangeItem:(MPMediaItem *)i;

@end

