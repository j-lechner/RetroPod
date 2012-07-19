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
