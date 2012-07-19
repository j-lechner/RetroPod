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
//  MediaMenuItem.m
//  Pod
//
//  Created by Johannes Lechner on 24.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "MediaMenuItem.h"

#import "MediaMenu.h"

#import "PushMenuAction.h"
#import "PlayMediaItemCollectionAction.h"

@implementation MediaMenuItem

@synthesize collection;
@synthesize item;

+ (MediaMenuItem *)menuItemForMPMediaItemCollection:(MPMediaItemCollection *)c 
									   withProperty:(NSString *)p;
{
	return [[[MediaMenuItem alloc] initForMPMediaItemCollection:c
												   withProperty:p] autorelease];
}

+ (MediaMenuItem *)menuItemForMPMediaItem:(MPMediaItem *)i
				  inMPMediaItemCollection:(MPMediaItemCollection *)c;
{
	return [[[MediaMenuItem alloc] initForMPMediaItem:i 
							  inMPMediaItemCollection:c] autorelease];
}

- (id)initForMPMediaItemCollection:(MPMediaItemCollection *)c
					  withProperty:(NSString *)p;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	self.showsArrow = YES;
	
	action = nil;
	menuText = nil;
	isCollection = YES;
	collection = [c retain];
	isItem = NO;
	property = [p retain];
	
	return self;
}

- (id)initForMPMediaItem:(MPMediaItem *)i
 inMPMediaItemCollection:(MPMediaItemCollection *)c;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	action = nil;
	menuText = nil;
	isCollection = NO;
	isItem = YES;
	item = [i retain];
	collection = [c retain];
	
	return self;
}

- (void)dealloc;
{
	[collection release];
	[item release];
	[property release];

	[super dealloc];
}

- (void)setMenuText:(NSString *)text;
{
}

- (NSString *)getMenuText;
{
	if(nil != menuText)
	{
		return menuText;
	}
	
	if(isCollection)
	{
		if(MPMediaPlaylistPropertyName == property)
		{
			MPMediaPlaylist *playlist = (MPMediaPlaylist*)collection;
			menuText = [[playlist valueForProperty:property] retain];
		}
		else
		{
			MPMediaItem *mediaItem = [collection representativeItem];
			menuText = [[mediaItem valueForProperty:property] retain];
		}
	}
	else if(isItem)
	{
		if(nil == item /* && [collection count] > 0*/)
		{
			item = [[[collection items] objectAtIndex:0] retain];
		}
		
		menuText = [[item valueForProperty:MPMediaItemPropertyTitle] retain];
	}
	
	return menuText;
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
	
	if(isCollection)
	{
		if([property isEqualToString:MPMediaItemPropertyArtist])
		{
			MPMediaQuery *albumsOfArtistQuery = [[MPMediaQuery alloc] init];
			albumsOfArtistQuery.groupingType = MPMediaGroupingAlbum;
			
			MPMediaPropertyPredicate *artistFilter = [MPMediaPropertyPredicate predicateWithValue:menuText
																					  forProperty:MPMediaItemPropertyArtist];
			[albumsOfArtistQuery addFilterPredicate:artistFilter];
			
			MediaMenu *menu = [MediaMenu menuForMPMediaQuery:albumsOfArtistQuery
												withProperty:MPMediaItemPropertyAlbumTitle];
			menu.headingText = menuText;
			action = [[PushMenuAction actionForMenu:menu] retain];
		}
		else if([property isEqualToString:MPMediaItemPropertyGenre])
		{
			MPMediaQuery *artistsOfGenreQuery = [MPMediaQuery artistsQuery];
			
			MPMediaPropertyPredicate *genreFilter = [MPMediaPropertyPredicate predicateWithValue:menuText
																					 forProperty:MPMediaItemPropertyGenre];
			[artistsOfGenreQuery addFilterPredicate:genreFilter];
			
			MediaMenu *menu = [MediaMenu menuForMPMediaQuery:artistsOfGenreQuery
												withProperty:MPMediaItemPropertyArtist];
			menu.headingText = menuText;
			action = [[PushMenuAction actionForMenu:menu] retain];
		}
		else if([property isEqualToString:MPMediaItemPropertyComposer])
		{
			MPMediaQuery *albumsOfComposerQuery = [MPMediaQuery albumsQuery];
			
			MPMediaPropertyPredicate *composerFilter = [MPMediaPropertyPredicate predicateWithValue:menuText
																						forProperty:MPMediaItemPropertyComposer];
			[albumsOfComposerQuery addFilterPredicate:composerFilter];
			
			MediaMenu *menu = [MediaMenu menuForMPMediaQuery:albumsOfComposerQuery
												withProperty:MPMediaItemPropertyAlbumTitle];
			menu.headingText = menuText;
			action = [[PushMenuAction actionForMenu:menu] retain];
		}
		else
		{
			MediaMenu *menu = [MediaMenu menuForMPMediaItemCollection:collection
														 withProperty:property];
			menu.headingText = menuText;
			action = [[PushMenuAction actionForMenu:menu] retain];
		}
	}
	else if(isItem)
	{
		if(nil == item && [collection count] > 0)
		{
			item = [[[collection items] objectAtIndex:0] retain];
		}
		
		action = [[PlayMediaItemCollectionAction actionForItemCollection:collection 
																withItem:item] retain];
	}
	
	return action;
}

@end
