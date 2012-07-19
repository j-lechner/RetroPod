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
//  PodController.h
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Content.h"
#import "ContentView.h"
#import "PopMenuAction.h"

//HACK!
#import "ScrollWheelView.h"

@class Action;

@interface PodController : NSObject {
	PodController *parentController;
	
	Content *content;
	ContentView *contentView;
	
	NSTimeInterval lastClickTimestamp;
}

@property (assign) PodController *parentController;
@property (readonly) Content *content;
@property (readonly) ContentView *contentView;

- (void)activate;
- (void)deactivate;

- (Action *)scrolledLeftAtTimestamp:(NSTimeInterval)t;
- (Action *)scrolledRightAtTimestamp:(NSTimeInterval)t;

- (Action *)didPressButton:(ScrollWheelButton)button;
- (Action *)didReleaseButton:(ScrollWheelButton)button;

- (Action *)didPressButton:(ScrollWheelButton)button withQueuedAction:(Action *)a;
- (Action *)didReleaseButton:(ScrollWheelButton)button withQueuedAction:(Action *)a;

@end
