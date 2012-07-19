//
//  PodController.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "PodController.h"

#import "Clicker.h"

@implementation PodController

@synthesize parentController;
@synthesize content;
@synthesize contentView;

- (id)init;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	parentController = nil;
	return self;
}

- (void)dealloc;
{
	[super dealloc];
}

- (void)activate;
{
}

- (void)deactivate;
{
}

- (Action *)scrolledLeftAtTimestamp:(NSTimeInterval)t;
{
	return nil;
}

- (Action *)scrolledRightAtTimestamp:(NSTimeInterval)t;
{
	return nil;
}

- (Action *)didPressButton:(ScrollWheelButton)button
{
	if(MenuButton == button)
	{
		[[Clicker clicker] playClick];
	}
	
	return [parentController didPressButton:button];
}

- (Action *)didReleaseButton:(ScrollWheelButton)button
{
	switch (button)
	{
		case MenuButton:
			return [PopMenuAction action];
			break;
		default:
			break;
	}
	
	return [parentController didReleaseButton:button];
}

- (Action *)didPressButton:(ScrollWheelButton)button withQueuedAction:(Action *)a;
{
	return [parentController didPressButton:button withQueuedAction:a];
}

- (Action *)didReleaseButton:(ScrollWheelButton)button withQueuedAction:(Action *)a;
{
	return [parentController didReleaseButton:button withQueuedAction:a];
}


@end
