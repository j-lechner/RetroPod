//
//  PlayerController.m
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "PlayerController.h"

#import "PlayMediaItemCollectionAction.h"
#import "ShowPlayerAction.h"
#import "ShuffleAllAction.h"

#import "Clicker.h"

@interface PlayerController (Private)

- (void)updateNowPlayingItem:(NSNotification *)not;

@end


@implementation PlayerController

@synthesize delegate;
@synthesize statusView;

- (id)initForView:(PlayerView *)view;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	musicPlayer = [[MPMusicPlayerController iPodMusicPlayer] retain];
	
	contentView = [view retain];
	isSettingVolume = YES;
	isDisplayingVolume = NO;
	userChangedVolume = NO;
	isScrubbing = NO;
	timelineUpdateTimer = nil;
	
	[musicPlayer beginGeneratingPlaybackNotifications];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updatePlaybackState:)
												 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateNowPlayingItem:)
												 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateVolume:)
												 name:MPMusicPlayerControllerVolumeDidChangeNotification
											   object:nil];
	
	[self updateNowPlayingItem:nil];
	return self;
}

- (void)dealloc;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[seekingTriggerTimer invalidate];
	seekingTriggerTimer = nil;
	
	[timelineUpdateTimer invalidate];
	[volumeDisplayingTimer invalidate];
	[scrubberDisplayingTimer invalidate];
	[currentCollection release];
	[currentCollectionItems release];
	
	[musicPlayer endGeneratingPlaybackNotifications];
	
	if(playAllSongsShuffled)
	{
		musicPlayer.shuffleMode = modeBeforePlayAllShuffledSongs;
	}
	
	[musicPlayer release];
	
	[super dealloc];
}

- (NSString *)stringForTimeInterval:(NSTimeInterval)interval;
{
	BOOL negative = NO;
	
	if(interval < 0.0)
	{
		negative = YES;
		interval *= -1.0;
	}
	
	unsigned int hours = (int)interval / 3600;
	interval -= 3600 * hours;
	unsigned int minutes = (int)interval / 60;
	interval -= 60 * minutes;
	unsigned int seconds = (int)interval;
	
	NSMutableString *timeString = [NSMutableString stringWithCapacity:10];
	
	if(negative)
	{
		[timeString appendString:@"-"];
	}
	if(hours > 0)
	{
		[timeString appendFormat:@"%d:%02d:%02d",hours,minutes,seconds];
	}
	else
	{
		[timeString appendFormat:@"%d:%02d",minutes,seconds];
	}
	
	return [NSString stringWithString:timeString];
}

- (void)updatePlaybackState:(NSNotification *)not;
{
	switch(musicPlayer.playbackState)
	{
		case MPMusicPlaybackStateStopped:
			statusView.status = Stopped;
			[delegate playerControllerDidStopPlayback:self];
			break;
		case MPMusicPlaybackStatePlaying:
			statusView.status = Playing;
			[delegate playerControllerDidStartPlayback:self];
			break;
		case MPMusicPlaybackStatePaused:
		case MPMusicPlaybackStateInterrupted:
			statusView.status = Paused; 
			break;
		default:
			break;
	}
}

- (StatusView*)statusView
{
	return statusView;
}

- (void)setStatusView:(StatusView *)view;
{
	statusView = view;
	[self updatePlaybackState:nil];
}

- (void)updateNowPlayingItem:(NSNotification *)not;
{
	DebugLog(@"START: UpdateNowPlayingItem");

	MPMediaItem *item = musicPlayer.nowPlayingItem;
	
	if(nil == item)
	{
		return;
	}
	
	PlayerView *view = (PlayerView *)contentView;

	unsigned int countOfItems = [currentCollectionItems count];
	unsigned int itemPosInCollection = [currentCollectionItems indexOfObject:item];

	if(NSNotFound != itemPosInCollection
	   && nil != currentCollectionItems
	   && MPMusicShuffleModeOff == musicPlayer.shuffleMode)
	{
		((PlayerView *)contentView).trackNumberLabel.text = 
		[NSString stringWithFormat:@"%d %@ %d",
		 itemPosInCollection+1,
		 NSLocalizedString(@"PlayerMofN",@""),
		 countOfItems];
	}
	else
	{
		((PlayerView *)contentView).trackNumberLabel.text = @"";
	}
	
	switch (musicPlayer.repeatMode) {
		case MPMusicRepeatModeNone:
		case MPMusicRepeatModeDefault:
			view.repeatState = PlayerRepeatOff;
			break;
		case MPMusicRepeatModeOne:
			view.repeatState = PlayerRepeatOne;
			break;
		case MPMusicRepeatModeAll:
			view.repeatState = PlayerRepeatAll;
			break;
	}
	
	switch (musicPlayer.shuffleMode) {
		case MPMusicShuffleModeOff:
		case MPMusicShuffleModeDefault:
			view.shuffleState = PlayerShuffleOff;
			break;
		case MPMusicShuffleModeSongs:
		case MPMusicShuffleModeAlbums:
			view.shuffleState = PlayerShuffleOn;
			break;
	}
	
	view.titleLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
	view.artistLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
	view.albumLabel.text = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
	
	timeElapsed = (int)musicPlayer.currentPlaybackTime;
	totalTime = (int)[[item valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
	
	view.timeElapsed = [self stringForTimeInterval:timeElapsed];
	view.timeRemaining = [self stringForTimeInterval:(totalTime-timeElapsed)*-1.0];
	
	[delegate playerController:self didChangeItem:item];
	DebugLog(@"END: UpdateNowPlayingItem");
}

- (void)updateTimeline:(NSTimer *)timer;
{
	PlayerView *view = (PlayerView *)contentView;
	
	timeElapsed = (int)musicPlayer.currentPlaybackTime;
	
	if(isScrubbing)
	{
		view.timeElapsed = [self stringForTimeInterval:scrubberTimeElapsed];
		view.timeRemaining = [self stringForTimeInterval:(totalTime-scrubberTimeElapsed)*-1.0];
		view.progress = scrubberTimeElapsed/totalTime;
	}
	else
	{
		view.timeElapsed = [self stringForTimeInterval:timeElapsed];
		view.timeRemaining = [self stringForTimeInterval:(totalTime-timeElapsed)*-1.0];
		view.progress = timeElapsed/totalTime;
	}
}

- (void)updateVolume:(NSNotification *)not;
{
	if(!userChangedVolume)
	{
		return;
	}
	
	isDisplayingVolume = YES;

	PlayerView *view = (PlayerView *)contentView;
	view.state = PlayerStateVolume;
	view.volume = musicPlayer.volume;
	
	[volumeDisplayingTimer invalidate];
	volumeDisplayingTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 
															 target:self 
														   selector:@selector(volumeTimeout:) 
														   userInfo:nil 
															repeats:NO];
}

- (void)volumeTimeout:(NSTimer *)timer;
{
	volumeDisplayingTimer = nil;
	isDisplayingVolume = NO;
	userChangedVolume = NO;

	PlayerView *view = (PlayerView *)contentView;
	view.state = PlayerStateNormal;
}

- (void)scrubbingTimeout:(NSTimer *)timer;
{
	scrubbingTimer = nil;
	
	isScrubbing = NO;
	
	musicPlayer.currentPlaybackTime = scrubberTimeElapsed;
	[self performSelector:@selector(updateTimeline:) 
			   withObject:nil 
			   afterDelay:0.5];
}

- (void)scrubberDisplayingTimeout:(NSTimer *)timer;
{
	scrubberDisplayingTimer = nil;
	isSettingVolume = YES;
	
	PlayerView *view = (PlayerView *)contentView;
	view.state = PlayerStateNormal;
}

- (void)activate;
{
	DebugLog(@"Activate: PlayerController");
	[super activate];
	PlayerView *view = (PlayerView *)contentView;
	[view reset];
	[self updateNowPlayingItem:nil];
	
	timelineUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
														   target:self 
														 selector:@selector(updateTimeline:) 
														 userInfo:nil 
														  repeats:YES];
}

- (void)deactivate;
{
	DebugLog(@"Deactivate: PlayerController");
	[super deactivate];
	[timelineUpdateTimer invalidate];
	timelineUpdateTimer = nil;
	
	isSettingVolume = YES;
}

- (double)currentAcceleration:(NSTimeInterval)t;
{
	double acceleration = 1.0;
	
	if(t - lastScrollTimestamp < 0.01)
	{
		acceleration = 6.0;
	}
	else if(t - lastScrollTimestamp < 0.05)
	{
		acceleration = 4.0;
	}
	else if(t - lastScrollTimestamp < 0.1)
	{
		acceleration = 2.0;
	}
	
	lastScrollTimestamp = t;
	
	return acceleration;
}

- (Action *)scrolledLeftAtTimestamp:(NSTimeInterval)t;
{
	double a = [self currentAcceleration:t];
	
	if(isSettingVolume)
	{
		volume = musicPlayer.volume;
		musicPlayer.volume = volume - 0.025 * a;
		volume = musicPlayer.volume;
		userChangedVolume = YES;
	}
	else
	{
		if(!isScrubbing)
		{
			isScrubbing = YES;
			scrubberTimeElapsed = musicPlayer.currentPlaybackTime;

			[scrubbingTimer invalidate];
			scrubbingTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 
															  target:self
															selector:@selector(scrubbingTimeout:)
															userInfo:nil
															 repeats:NO];
		}
		
		scrubberTimeElapsed = scrubberTimeElapsed - 5.0 * a;
		if(scrubberTimeElapsed < 0.0)
		{
			scrubberTimeElapsed = 0.0;
		}
		
		PlayerView *view = (PlayerView *)contentView;
		view.state = PlayerStateScrubbing;
		view.progress = scrubberTimeElapsed/totalTime;

		[scrubberDisplayingTimer invalidate];
		scrubberDisplayingTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 
																   target:self 
																 selector:@selector(scrubberDisplayingTimeout:) 
																 userInfo:nil 
																  repeats:NO];
	}
	
	return nil;
}

- (Action *)scrolledRightAtTimestamp:(NSTimeInterval)t;
{
	double a = [self currentAcceleration:t];
	
	if(isSettingVolume)
	{
		volume = musicPlayer.volume;
		musicPlayer.volume = volume + 0.025 * a;
		volume = musicPlayer.volume;
		userChangedVolume = YES;
	}
	else
	{
		if(!isScrubbing)
		{
			isScrubbing = YES;
			scrubberTimeElapsed = musicPlayer.currentPlaybackTime;
			
			[scrubbingTimer invalidate];
			scrubbingTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 
															  target:self
															selector:@selector(scrubbingTimeout:)
															userInfo:nil
															 repeats:NO];
		}
		
		scrubberTimeElapsed = scrubberTimeElapsed + 5.0 * a;
		if(scrubberTimeElapsed > totalTime)
		{
			scrubberTimeElapsed = totalTime;
		}
		
		PlayerView *view = (PlayerView *)contentView;
		view.state = PlayerStateScrubbing;
		view.progress = scrubberTimeElapsed/totalTime;
		
		[scrubberDisplayingTimer invalidate];
		scrubberDisplayingTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 
																   target:self 
																 selector:@selector(scrubberDisplayingTimeout:) 
																 userInfo:nil 
																  repeats:NO];
	}
	
	return nil;
}

- (Action *)didPressButton:(ScrollWheelButton)button;
{
	if(CenterButton == button)
	{
		if(volumeDisplayingTimer != nil || scrubberDisplayingTimer != nil)
		{
			[volumeDisplayingTimer invalidate];
			volumeDisplayingTimer = nil;
			[scrubberDisplayingTimer invalidate];
			scrubberDisplayingTimer = nil;
			
			if(isScrubbing)
			{
				[scrubbingTimer invalidate];
				scrubbingTimer = nil;
				
				isScrubbing = NO;
				musicPlayer.currentPlaybackTime = scrubberTimeElapsed;
			}
			
			PlayerView *view = (PlayerView *)contentView;
			view.state = PlayerStateNormal;
			
			isSettingVolume = YES;
		}
		else
		{
			isSettingVolume = !isSettingVolume;
			
			if(!isSettingVolume)
			{
				PlayerView *view = (PlayerView *)contentView;
				view.state = PlayerStateScrubbing;
				view.progress = musicPlayer.currentPlaybackTime/totalTime;
				
				[scrubberDisplayingTimer invalidate];
				scrubberDisplayingTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 
																		   target:self 
																		 selector:@selector(scrubberDisplayingTimeout:) 
																		 userInfo:nil 
																		  repeats:NO];
			}
		}
		
		return nil;
	}
	
	if(PreviousButton == button || NextButton == button)
	{
		[[Clicker clicker] playClick];

		isSeeking = NO;
		pressedButton = button;
		seekingTriggerTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 
															   target:self 
															 selector:@selector(beginSeeking:) 
															 userInfo:nil 
															  repeats:NO];
		return nil;
	}
	
	if(PlayButton == button)
	{
		[[Clicker clicker] playClick];
	}
	
	return [parentController didPressButton:button];
}

- (void)beginSeeking:(NSTimer*)timer;
{
	isSeeking = YES;
	seekingTriggerTimer = nil;

	if(PreviousButton == pressedButton)
	{
		[musicPlayer beginSeekingBackward];
	}
	if(NextButton == pressedButton)
	{
		[musicPlayer beginSeekingForward];
	}
}

- (Action *)didReleaseButton:(ScrollWheelButton)button;
{
	switch (button) 
	{
		case PreviousButton:
		{
			[seekingTriggerTimer invalidate];
			seekingTriggerTimer = nil;

			if(isSeeking)
			{
				isSeeking = NO;
				pressedButton = NoButton;
				[musicPlayer endSeeking];
			}
			else
			{
				if(timeElapsed <= 2.0)
				{
					[self skipToPrev];
				}
				else
				{
					[self skipToStart];
				}
			}
		}
			break;
		case NextButton:
		{
			[seekingTriggerTimer invalidate];
			seekingTriggerTimer = nil;
			
			if(isSeeking)
			{
				isSeeking = NO;
				pressedButton = NoButton;
				[musicPlayer endSeeking];
			}
			else
			{
				[self skipToNext];
			}
		}
			break;
		case PlayButton:
		{
			[self playPauseToogle];
			break;
		}
		default:
		{
			
		}
			break;
	}
	
	return [parentController didReleaseButton:button];
}

- (Action *)didPressButton:(ScrollWheelButton)button withQueuedAction:(Action *)a;
{
	if(nil == a)
	{
		return [self didPressButton:button];
	}
	
	if(CenterButton == button)
	{
		if([a isKindOfClass:[PlayMediaItemCollectionAction class]])
		{
			PlayMediaItemCollectionAction *action = (PlayMediaItemCollectionAction*)a;
			
			unsigned long long nowID = 1;
			unsigned long long nextID = 2;
			
			nowID = [[musicPlayer.nowPlayingItem 
					  valueForProperty:MPMediaItemPropertyPersistentID]
					 unsignedLongLongValue];
			
			nextID = [[action.item 
					   valueForProperty:MPMediaItemPropertyPersistentID] 
					  unsignedLongLongValue];
				
			if(nowID != nextID || currentCollection != action.collection)
			{
				[self playItem:action.item inCollection:action.collection];
			}
			
			return [ShowPlayerAction action];
		}
		else if([a isKindOfClass:[ShuffleAllAction class]])
		{
			[self playAllSongsShuffled];
			return [ShowPlayerAction action];
		}
	}
	
	return [parentController didPressButton:button withQueuedAction:a];
}	

- (Action *)didReleaseButton:(ScrollWheelButton)button withQueuedAction:(Action *)a;
{
	if(PlayButton == button && [a isKindOfClass:[PlayMediaItemCollectionAction class]])
	{
		if([a isKindOfClass:[PlayMediaItemCollectionAction class]])
		{
			if(self.playing)
			{
				return [self didReleaseButton:button];
			}
			else
			{
				if([a isKindOfClass:[PlayMediaItemCollectionAction class]])
				{
					PlayMediaItemCollectionAction *action = (PlayMediaItemCollectionAction*)a;
					[self playItem:action.item inCollection:action.collection];
					return [ShowPlayerAction action];
				}
			}
		}
	}
	
	return [parentController didReleaseButton:button withQueuedAction:a];
}

- (BOOL)playing;
{
	return MPMusicPlaybackStatePlaying == musicPlayer.playbackState;
}

- (BOOL)stopped;
{
	return MPMusicPlaybackStateStopped == musicPlayer.playbackState;
}

- (void)skipToStart;
{
	[musicPlayer skipToBeginning];
}

- (void)skipToPrev;
{
	[musicPlayer skipToPreviousItem];
}

- (void)skipToNext;
{
	[musicPlayer skipToNextItem];
}

- (void)playPauseToogle;
{
	if(MPMusicPlaybackStatePlaying == musicPlayer.playbackState)
	{
		[musicPlayer pause];
	}
	else if(MPMusicPlaybackStatePaused == musicPlayer.playbackState
			|| MPMusicPlaybackStateInterrupted == musicPlayer.playbackState)
	{
		[musicPlayer play];
	}
}

- (void)playItem:(MPMediaItem *)i inCollection:(MPMediaItemCollection *)c;
{
	if(playAllSongsShuffled)
	{
		playAllSongsShuffled = NO;
		musicPlayer.shuffleMode = modeBeforePlayAllShuffledSongs;
	}
	
	if(c != currentCollection)
	{
		[c retain];
		[currentCollection release];
		currentCollection = c;
		
		NSArray *items = [[currentCollection items] retain];
		[currentCollectionItems release];
		currentCollectionItems = items;
		
		[delegate playerController:self 
			   didChangeCollection:currentCollection];
	}
	
	MPMusicShuffleMode sMode = musicPlayer.shuffleMode;
	
	[musicPlayer setQueueWithItemCollection:c];
	musicPlayer.shuffleMode = MPMusicShuffleModeOff;
	
	if(nil != i)
	{
		musicPlayer.nowPlayingItem = i;
	}

	[self updateNowPlayingItem:nil];
	[musicPlayer play];
	musicPlayer.shuffleMode = sMode;
}

- (void)playAllSongsShuffled;
{
	if(!playAllSongsShuffled)
	{
		modeBeforePlayAllShuffledSongs = musicPlayer.shuffleMode;
	}
	playAllSongsShuffled = YES;
	
	[currentCollection release];
	currentCollection = nil;
	
	[currentCollectionItems release];
	currentCollectionItems = nil;
	
	[delegate playerController:self 
		   didChangeCollection:nil];
	
	[musicPlayer setQueueWithQuery:[MPMediaQuery songsQuery]];
	musicPlayer.shuffleMode = MPMusicShuffleModeSongs;
	[musicPlayer play];
}

@end
