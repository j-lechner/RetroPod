//
//  MediaMenu.h
//  Pod
//
//  Created by Johannes Lechner on 24.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Menu.h"

@interface MediaMenu : Menu {
	BOOL showsQueryCollections;
	MPMediaQuery *query;
	NSString *property;
	BOOL ranQuery;
	NSArray *queryCollections;

	BOOL showsMpCollectionItems;
	BOOL showsArrayCollectionItems;
	MPMediaItemCollection *mpCollection;
	NSArray *arrayCollection;
}

@property (readonly) MPMediaItemCollection *collection;

+ (id)menuForMPMediaQuery:(MPMediaQuery *)q withProperty:(NSString *)p;
+ (id)menuForMPMediaItemCollection:(MPMediaItemCollection *)c withProperty:(NSString *)p;
+ (id)menuForMediaItemCollection:(NSArray *)c withProperty:(NSString *)p;

- (id)initWithMPMediaQuery:(MPMediaQuery *)q withProperty:(NSString *)p;
- (id)initWithMPMediaItemCollection:(MPMediaItemCollection *)c withProperty:(NSString *)p;
- (id)initWithMediaItemCollection:(NSArray *)c withProperty:(NSString *)p;

@end
