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
