//
//  MainMenu.h
//  Pod
//
//  Created by Johannes Lechner on 10.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Menu.h"

@interface MainMenu : Menu {
	BOOL showsLastItem;
}

@property (assign, setter=setShowsLastItem:) BOOL showsLastItem;

@end
