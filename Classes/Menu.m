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
//  Menu.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "Menu.h"

@implementation Menu

@synthesize menuItems;
@synthesize selectedMenuItem;
@synthesize scrollOffset;

- (id)initWithMenuItems:(NSArray*)items;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	scrollOffset = 0;
	menuItems = [items retain];
	
	if([menuItems count] > 0)
	{
		selectedMenuItem = [menuItems objectAtIndex:0];
		selectedMenuItem.selected = YES;
	}
	
	return self;
}

- (void)dealloc;
{
	[menuItems release];
	[selectedMenuItem release];
	[super dealloc];
}

- (NSArray *)visibleMenuItems;
{
	NSUInteger scrollSize = [self.menuItems count];
	if([self.menuItems count] > 6)
	{
		scrollSize = 6;
	}
	
	return [self.menuItems subarrayWithRange:NSMakeRange(scrollOffset,scrollSize)];
}


- (BOOL)scrollUpBy:(unsigned int)count;
{
	if(0 == [self.menuItems count])
	{
		return NO;
	}
	
	NSUInteger currentPos = [self.menuItems indexOfObject:selectedMenuItem];
	NSUInteger previousPos = currentPos; 

	if(currentPos != scrollOffset)
	{
		count = 1;
	}
	
	int overlap = currentPos - count;
	currentPos -= count + ((overlap < 0) ? overlap : 0);
	
	if(currentPos < scrollOffset)
	{
		scrollOffset = currentPos;
	}
	
	selectedMenuItem.selected = NO;
	selectedMenuItem = [self.menuItems objectAtIndex:currentPos];
	selectedMenuItem.selected = YES;
	
	return (currentPos != previousPos);
}

- (BOOL)scrollDownBy:(unsigned int)count;
{
	if(0 == [self.menuItems count])
	{
		return NO;
	}
	
	NSUInteger currentPos = [self.menuItems indexOfObject:selectedMenuItem];
	NSUInteger previousPos = currentPos; 
	
	if(currentPos-scrollOffset < 5)
	{
		count = 1;
	}
	
	int overlap = (currentPos + count) - ([self.menuItems count] - 1);
	currentPos += count - ((overlap > 0) ? overlap : 0);

	if(currentPos >= (scrollOffset + 6))
	{
		scrollOffset = currentPos - 5;
	}
	
	selectedMenuItem.selected = NO;
	selectedMenuItem = [self.menuItems objectAtIndex:currentPos];
	selectedMenuItem.selected = YES;
	
	return (currentPos != previousPos);
}

@end
