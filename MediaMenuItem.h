//
//  MediaMenuItem.h
//  Pod
//
//  Created by Johannes Lechner on 24.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "MenuItem.h"

@interface MediaMenuItem : MenuItem {
	BOOL isCollection;
	MPMediaItemCollection *collection;
	BOOL isItem;
	MPMediaItem *item;
	NSString *property;
}

@property (readonly) MPMediaItemCollection *collection;
@property (readonly) MPMediaItem *item;

+ (MediaMenuItem *)menuItemForMPMediaItemCollection:(MPMediaItemCollection *)c 
									   withProperty:(NSString *)property;
+ (MediaMenuItem *)menuItemForMPMediaItem:(MPMediaItem *)i
							 inMPMediaItemCollection:(MPMediaItemCollection *)c;

- (id)initForMPMediaItemCollection:(MPMediaItemCollection *)c
					  withProperty:(NSString *)p;
- (id)initForMPMediaItem:(MPMediaItem *)i
 inMPMediaItemCollection:(MPMediaItemCollection *)c;

@end
