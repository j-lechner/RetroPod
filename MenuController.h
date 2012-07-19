//
//  MenuController.h
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "PodController.h"

#import "Menu.h"
#import "MenuView.h"
#import "MediaMenu.h"
#import "MediaMenuItem.h"

@interface MenuController : PodController {
	Menu *menu;
	MenuView *menuView;
	
	NSTimeInterval lastScrollTimestamp;
	
	MPMediaItemCollection *currentCollection;
	MPMediaItem *currentItem;
	MediaMenuItem *playingItem;
}

@property (retain) MPMediaItemCollection *currentCollection;
@property (retain,setter=setCurrentItem:) MPMediaItem *currentItem;

@property (retain,setter=setMenu:) Menu *menu;
@property (retain) MenuView *menuView;

@end
