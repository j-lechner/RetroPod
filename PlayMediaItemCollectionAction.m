//
//  PlayMediaItemCollectionAction.m
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "PlayMediaItemCollectionAction.h"


@implementation PlayMediaItemCollectionAction

@synthesize collection;
@synthesize item;

+ (PlayMediaItemCollectionAction*)actionForItemCollection:(MPMediaItemCollection*)c 
												 withItem:(MPMediaItem *)i;
{
	PlayMediaItemCollectionAction *action = [[PlayMediaItemCollectionAction alloc] init];
	action.collection = c;
	action.item = i;
	
	return [action autorelease];
}

- (void)dealloc;
{
	[collection release];
	[item release];
	[super dealloc];
}

@end
