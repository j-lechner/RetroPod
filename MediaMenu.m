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
//  MediaMenu.m
//  Pod
//
//  Created by Johannes Lechner on 24.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "MediaMenu.h"

#import "PushMenuAction.h"

#import "MediaMenuItem.h"
#import "MediaAllSelectorMenuItem.h"

@implementation MediaMenu

@synthesize collection;

+ (id)menuForMPMediaQuery:(MPMediaQuery *)q withProperty:(NSString *)p;
{
	MediaMenu *menu = [[MediaMenu alloc] initWithMPMediaQuery:q 
												 withProperty:p];
	return [menu autorelease];
}

+ (id)menuForMPMediaItemCollection:(MPMediaItemCollection *)c withProperty:(NSString *)p;
{
	MediaMenu *menu = [[MediaMenu alloc] initWithMPMediaItemCollection:c withProperty:p];
	return [menu autorelease];
}

+ (id)menuForMediaItemCollection:(NSArray *)c withProperty:(NSString *)p;
{
	MediaMenu *menu = [[MediaMenu alloc] initWithMediaItemCollection:c withProperty:p];
	return [menu autorelease];
}

- (id)initWithMPMediaQuery:(MPMediaQuery *)q withProperty:(NSString *)p;
{
	if(!(self = [super init]))
	{
		return nil;
	}

	showsQueryCollections = YES;
	query = [q retain];
	property = [p retain];
	ranQuery = NO;

	showsMpCollectionItems = NO;
	showsArrayCollectionItems = NO;
	
	return self;
}

- (id)initWithMPMediaItemCollection:(MPMediaItemCollection *)c withProperty:(NSString *)p;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	showsQueryCollections = NO;

	showsMpCollectionItems = YES;
	showsArrayCollectionItems = NO;

	mpCollection = [c retain];
	property = [p retain];
	ranQuery = NO;
	
	return self;
}

- (id)initWithMediaItemCollection:(NSArray *)c withProperty:(NSString *)p;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	showsQueryCollections = NO;
	
	showsMpCollectionItems = NO;
	showsArrayCollectionItems = YES;
	mpCollection = nil;
	arrayCollection = [c retain];
	property = [p retain];
	ranQuery = NO;
	
	return self;
}

- (void)dealloc;
{
	[query release];
	[property release];
	[queryCollections release];
	[mpCollection release];
	[arrayCollection release];
	
	[super dealloc];
}

- (NSArray *)menuItems;
{
	if(showsQueryCollections && !ranQuery)
	{
		DebugLog(@"START: Query");
		
		queryCollections = [[query collections] retain];
		super.menuItems = [NSMutableArray arrayWithCapacity:[queryCollections count]+1];
		
		if([MPMediaItemPropertyGenre isEqualToString:property])
		{
			MediaMenu *artistsMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery artistsQuery]
													   withProperty:MPMediaItemPropertyArtist];
			artistsMenu.headingText = NSLocalizedString(@"MenuAllArtists",@"");
			
			MenuItem *allItem = [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuAll",@"")
												   andNextMenu:artistsMenu];
			
			[(NSMutableArray *)super.menuItems addObject:allItem];
		}
		
		if([MPMediaItemPropertyArtist isEqualToString:property] 
		   || [MPMediaItemPropertyComposer isEqualToString:property])
		{
			MediaMenu *albumsMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery albumsQuery]
													  withProperty:MPMediaItemPropertyAlbumTitle];
			albumsMenu.headingText = NSLocalizedString(@"MenuAllAlbums",@"");
			
			MenuItem *allItem = [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuAll",@"")
												   andNextMenu:albumsMenu];
			
			[(NSMutableArray *)super.menuItems addObject:allItem];
		}
		
		if([MPMediaItemPropertyAlbumTitle isEqualToString:property])
		{
			MediaAllSelectorMenuItem *allItem = [MediaAllSelectorMenuItem allMenuItemForProperty:property 
																			combiningCollections:queryCollections];
			[(NSMutableArray *)super.menuItems addObject:allItem];
		}
		
		if([MPMediaItemPropertyTitle isEqualToString:property])
		{
			for(MPMediaItemCollection *c in queryCollections)
			{
				MediaMenuItem *item = [MediaMenuItem menuItemForMPMediaItem:nil
													inMPMediaItemCollection:c];
				[(NSMutableArray *)super.menuItems addObject:item];
			}
		}
		else
		{
			for(MPMediaItemCollection *c in queryCollections)
			{
				MediaMenuItem *item = [MediaMenuItem menuItemForMPMediaItemCollection:c
																		 withProperty:property];
				[(NSMutableArray *)super.menuItems addObject:item];
			}
		}
			
		
		if([super.menuItems count] > 0)
		{
			super.selectedMenuItem = [super.menuItems objectAtIndex:0];
			super.selectedMenuItem.selected = YES;
		}
		
		ranQuery = YES;

		DebugLog(@"END: Query");
	}
	if((showsMpCollectionItems || showsArrayCollectionItems) && !ranQuery)
	{
		DebugLog(@"START: Query");
		
		NSArray *mediaItems = nil;
		
		if(showsMpCollectionItems)
		{
			mediaItems = [mpCollection items];
			super.menuItems = [NSMutableArray arrayWithCapacity:[mpCollection count]];
		}
		else
		{
			mediaItems = arrayCollection;
			super.menuItems = [NSMutableArray arrayWithCapacity:[mediaItems count]];
		}

		for(MPMediaItem *mediaItem in mediaItems)
		{
			MediaMenuItem *menuItem = [MediaMenuItem menuItemForMPMediaItem:mediaItem 
													inMPMediaItemCollection:mpCollection];
			[(NSMutableArray *)super.menuItems addObject:menuItem];
		}
		
		if([super.menuItems count] > 0)
		{
			super.selectedMenuItem = [super.menuItems objectAtIndex:0];
			super.selectedMenuItem.selected = YES;
		}
		
		ranQuery = YES;
		
		DebugLog(@"END: Query");
	}
	
	return super.menuItems;
}

- (NSArray *)visibleMenuItems;
{
	NSUInteger scrollSize = [self.menuItems count];
	if([self.menuItems count] > 6)
	{
		scrollSize = 6;
	}
	
	NSRange range = NSMakeRange(super.scrollOffset,scrollSize);
	return [self.menuItems subarrayWithRange:range];
}

@end
