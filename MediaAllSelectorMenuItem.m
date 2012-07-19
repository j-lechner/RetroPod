//
//  MediaAllSelectorMenuItem.m
//  Pod
//
//  Created by Johannes Lechner on 25.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "MediaAllSelectorMenuItem.h"

#import "MediaMenu.h"
#import "PushMenuAction.h"

@implementation MediaAllSelectorMenuItem

+ (MediaAllSelectorMenuItem *)allMenuItemForProperty:(NSString *)property 
								combiningCollections:(NSArray *)collections;
{
	return [[MediaAllSelectorMenuItem alloc] initAllMenuItemForProperty:property 
												   combiningCollections:collections];
}

- (id)initAllMenuItemForProperty:(NSString *)p 
			combiningCollections:(NSArray *)c;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	self.showsArrow = YES;
	
	property = [p retain];
	collections = [[NSMutableArray alloc] initWithArray:c];
	
	return self;
}

- (void)dealloc;
{
	[property release];
	[collections release];
	[super dealloc];
}

- (void)setMenuText:(NSString *)text;
{
}

- (NSString *)getMenuText;
{
	return NSLocalizedString(@"MenuAll",@"");
}

- (void)setAction:(Action *)a;
{
}

- (Action *)action;
{
	if(action != nil)
	{
		return action;
	}
	
	if([MPMediaItemPropertyAlbumTitle isEqualToString:property])
	{
/*		MPMediaQuery *songs = [MPMediaQuery songs];
		albumsOfArtistQuery.groupingType = MPMediaGroupingAlbum;
		
		MPMediaPropertyPredicate *artistFilter = [MPMediaPropertyPredicate predicateWithValue:menuText
																				  forProperty:MPMediaItemPropertyArtist];
		[albumsOfArtistQuery addFilterPredicate:artistFilter];
		
		MediaMenu *menu = [MediaMenu menuForMPMediaQuery:albumsOfArtistQuery
											withProperty:MPMediaItemPropertyAlbumTitle];
		menu.headingText = menuText;
		action = [[PushMenuAction actionForMenu:menu] retain];*/
		
		NSMutableArray *songs = [NSMutableArray arrayWithCapacity:4096];

		for(MPMediaItemCollection *collection in collections)
		{
			[songs addObjectsFromArray:collection.items];
		}

		if([songs count] > 0)
		{
			MPMediaItemCollection *allSongsByAlbum = [[MPMediaItemCollection alloc] initWithItems:songs];
			
			MediaMenu *menu = [MediaMenu menuForMPMediaItemCollection:allSongsByAlbum 
														 withProperty:MPMediaItemPropertyAlbumTitle];
			menu.headingText = NSLocalizedString(@"MenuAllSongs",@"");
			action = [[PushMenuAction actionForMenu:menu] retain];
			
			[allSongsByAlbum release];
		}
	}
	
	return action;
}

@end
