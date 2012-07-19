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
