//
//  PushMenuAction.m
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "PushMenuAction.h"


@implementation PushMenuAction

@synthesize menu;

+ (PushMenuAction*)actionForMenu:(Menu*)m;
{
	PushMenuAction *action = [[PushMenuAction alloc] init];
	action.menu = m;
	return [action autorelease];
}

- (void)dealloc;
{
	[menu release];
	[super dealloc];
}

@end
