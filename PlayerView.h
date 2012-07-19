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
