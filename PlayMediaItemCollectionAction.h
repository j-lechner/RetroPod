//
//  PlayMediaItemCollectionAction.h
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "Action.h"

@interface PlayMediaItemCollectionAction : Action {
	MPMediaItemCollection *collection;
	MPMediaItem *item;
}

@property (retain) MPMediaItemCollection *collection;
@property (retain) MPMediaItem *item;

+ (PlayMediaItemCollectionAction*)actionForItemCollection:(MPMediaItemCollection*)c 
												 withItem:(MPMediaItem *)i;

@end
