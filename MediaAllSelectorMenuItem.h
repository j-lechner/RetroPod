//
//  MediaAllSelectorMenuItem.h
//  Pod
//
//  Created by Johannes Lechner on 25.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "MenuItem.h"

@interface MediaAllSelectorMenuItem : MenuItem {
	NSString *property;
	NSArray *collections;
}

+ (MediaAllSelectorMenuItem *)allMenuItemForProperty:(NSString *)property 
								combiningCollections:(NSArray *)collections;

- (id)initAllMenuItemForProperty:(NSString *)p 
			combiningCollections:(NSArray *)c;

@end
