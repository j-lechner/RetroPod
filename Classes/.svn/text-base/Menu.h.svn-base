//
//  Menu.h
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Content.h"
#import "MenuItem.h"

@interface Menu : Content {
	NSArray *menuItems;
	MenuItem *selectedMenuItem;
	NSUInteger scrollOffset;
}

@property (retain,getter=menuItems) NSArray *menuItems;
@property (retain) MenuItem *selectedMenuItem;
@property (assign) NSUInteger scrollOffset;

- (id)initWithMenuItems:(NSArray*)items;
- (NSArray *)visibleMenuItems;

- (BOOL)scrollUpBy:(unsigned int)count;
- (BOOL)scrollDownBy:(unsigned int)count;

@end
