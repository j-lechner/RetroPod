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
//  MenuItem.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "MenuItem.h"
#import "PushMenuAction.h"


@implementation MenuItem

@synthesize menuText;
@synthesize menuRightText;
@synthesize showsArrow;
@synthesize showsSpeaker;
@synthesize isPlaying;
@synthesize selected;
@synthesize action;

+ (MenuItem *)menuItemWithMenuText:(NSString *)menuText;
{
	return [MenuItem menuItemWithMenuText:menuText 
							  andNextMenu:nil];
}

+ (MenuItem *)menuItemWithMenuText:(NSString *)menuText andNextMenu:(Menu *)m;
{
	MenuItem *item = [[MenuItem alloc] init];
	item.menuText = menuText;
	item.menuRightText = nil;
	item.showsArrow = (m != nil);
	item.showsSpeaker = NO;
	item.isPlaying = NO;
	item.action = (m != nil) ? [PushMenuAction actionForMenu:m] : nil;
	return [item autorelease];
}

+ (MenuItem *)menuItemWithMenuText:(NSString *)menuText andAction:(Action *)a;
{
	MenuItem *item = [[MenuItem alloc] init];
	item.menuText = menuText;
	item.menuRightText = nil;
	item.showsArrow = (a != nil);
	item.showsSpeaker = NO;
	item.isPlaying = NO;
	item.action = (a != nil) ? a : nil;
	return [item autorelease];
}

- (void)dealloc;
{
	[menuText release];
	[menuRightText release];
	[action release];

	[super dealloc];
}

@end
