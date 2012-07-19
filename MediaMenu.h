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
