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
