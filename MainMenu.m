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
