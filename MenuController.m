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
//  MenuController.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "MenuController.h"

#import "Clicker.h"

#import "PlayMediaItemCollectionAction.h"
#import "ShuffleAllAction.h"
#import "SettingsAction.h"
#import "MediaMenuItem.h"

@implementation MenuController

@synthesize menu;
@synthesize menuView;

@synthesize currentCollection;
@synthesize currentItem;

- (id)init;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	currentItem = nil;
	playingItem = nil;
	return self;
}

- (void)dealloc;
{
	[menu release];
	[menuView release];
	[currentCollection release];
	[currentItem release];
	[playingItem release];
	[super dealloc];
}

- (Action *)scrolledLeftAtTimestamp:(NSTimeInterval)t;
{
	BOOL didScroll = NO;
	
	if(t - lastScrollTimestamp < 0.01)
	{
		didScroll = [menu scrollUpBy:11];
	}
	else if(t - lastScrollTimestamp < 0.04)
	{
		didScroll = [menu scrollUpBy:7];
	}
	else if(t - lastScrollTimestamp < 0.09)
	{
		didScroll = [menu scrollUpBy:3];
	}
	else
	{
		didScroll = [menu scrollUpBy:1];
	}
	
	lastScrollTimestamp = t;
	
	if(didScroll)
	{
		[[Clicker clicker] playClick];
	}
	
	menuView.menu = menu;
	return nil;
}

- (Action *)scrolledRightAtTimestamp:(NSTimeInterval)t;
{
	BOOL didScroll = NO;
	
	if(t - lastScrollTimestamp < 0.01)
	{
		didScroll = [menu scrollDownBy:11];
	}
	if(t - lastScrollTimestamp < 0.04)
	{
		didScroll = [menu scrollDownBy:7];
	}
	else if(t - lastScrollTimestamp < 0.09)
	{
		didScroll = [menu scrollDownBy:3];
	}
	else
	{
		didScroll = [menu scrollDownBy:1];
	}
	
	lastScrollTimestamp = t;
	
	if(didScroll)
	{
		[[Clicker clicker] playClick];
	}
	
	menuView.menu = menu;
	return nil;
}

- (Action *)didPressButton:(ScrollWheelButton)button
{
	if(CenterButton == button)
	{
		Action *a = menu.selectedMenuItem.action;
		
		if(a != nil)
		{
			if([a isKindOfClass:[PlayMediaItemCollectionAction class]]
			   || [a isKindOfClass:[ShuffleAllAction class]])
			{
				return [parentController didPressButton:button 
									   withQueuedAction:a];
			}
			if([a isKindOfClass:[SettingsAction class]])
			{
				SettingsAction *sa = (SettingsAction *)a;
				[sa changeSetting];
				menuView.menu = menu;
				
				return nil;
			}
			
			return menu.selectedMenuItem.action;
		}
		
		return nil;
	}
	
	return [parentController didPressButton:button];
}

- (Action *)didReleaseButton:(ScrollWheelButton)button;
{
	MediaMenuItem *item = (MediaMenuItem *)menu.selectedMenuItem;
	
	if(PlayButton == button && [item isKindOfClass:[MediaMenuItem class]])
	{
		Action *a =	[PlayMediaItemCollectionAction actionForItemCollection:item.collection
																  withItem:item.item];
		
		return [parentController didReleaseButton:button withQueuedAction:a];
	}
	
	return [parentController didReleaseButton:button];
}

- (Menu*)menu
{
	return menu;
}

- (void)setMenu:(Menu *)m;
{
	[m retain];
	[menu release];
	menu = m;
	
	playingItem.showsSpeaker = NO;
	[playingItem release];
	playingItem = nil;
	
	if([menu isKindOfClass:[MediaMenu class]])
	{
		MediaMenu *mm = (MediaMenu *)menu;
		
		if(mm.collection == currentCollection)
		{
			unsigned long long cID;
			
			if(nil != currentItem)
			{
				cID = [[currentItem 
						valueForProperty:MPMediaItemPropertyPersistentID] 
					   unsignedLongLongValue];
			}
			
			for(MediaMenuItem *item in [mm visibleMenuItems])
			{
				if(![item isKindOfClass:[MediaMenuItem class]])
				{
					continue;
				}
				
				unsigned long long iID = [[item.item 
										   valueForProperty:MPMediaItemPropertyPersistentID]
										  unsignedLongLongValue];
				
				if(nil != currentItem &&
				   nil != item.item &&
				   iID == cID)
				{
					playingItem = [item retain];
					playingItem.showsSpeaker = YES;
				}
			}
		}
	}
	
	menuView.menu = m;
}

- (MPMediaItem*)currentItem
{
	return currentItem;
}

- (void)setCurrentItem:(MPMediaItem *)item;
{
	[item retain];
	[currentItem release];
	currentItem = item;

	playingItem.showsSpeaker = NO;
	[playingItem release];
	playingItem = nil;
	
	if([menu isKindOfClass:[MediaMenu class]])
	{
		MediaMenu *mm = (MediaMenu *)menu;
		
		if(mm.collection == currentCollection)
		{
			unsigned long long cID;
			
			if(nil != currentItem)
			{
				cID = [[currentItem 
						valueForProperty:MPMediaItemPropertyPersistentID] 
					   unsignedLongLongValue];
			}
			
			for(MediaMenuItem *item in [mm visibleMenuItems])
			{
				if(![item isKindOfClass:[MediaMenuItem class]])
				{
					continue;
				}
				
				unsigned long long iID = [[item.item 
										   valueForProperty:MPMediaItemPropertyPersistentID]
										  unsignedLongLongValue];
				
				if(nil != currentItem &&
				   nil != item.item &&
				   iID == cID)
				{
					playingItem = [item retain];
					playingItem.showsSpeaker = YES;
				}
			}
		}
	}
	
	menuView.menu = menu;
}

@end
