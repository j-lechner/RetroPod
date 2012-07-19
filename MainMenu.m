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
//  MainMenu.m
//  Pod
//
//  Created by Johannes Lechner on 10.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "MainMenu.h"


@implementation MainMenu

@synthesize showsLastItem;

- (NSArray *)menuItems;
{
	if(showsLastItem || [menuItems count] < 2)
	{
		return menuItems;
	}
	else
	{
		return [menuItems subarrayWithRange:NSMakeRange(0, [menuItems count]-1)];
	}
}

- (BOOL)showsLastItem
{
	return showsLastItem;
}

- (void)setShowsLastItem:(BOOL)li;
{
	if(showsLastItem && !li)
	{
		if([menuItems count] > 0)
		{
			selectedMenuItem.selected = NO;
			selectedMenuItem = [menuItems objectAtIndex:0];
			selectedMenuItem.selected = YES;
		}
		
		scrollOffset = 0;
	}
	
	showsLastItem = li;
}

@end
