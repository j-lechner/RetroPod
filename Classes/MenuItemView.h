//
//  MenuItemView.h
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentView.h"
#import "MenuItem.h"

@interface MenuItemView : ContentView {
	UILabel *itemLabel;
	UILabel *itemRightLabel;
	
	MenuItem *menuItem;
}

@property (retain,setter=setMenuItem:) MenuItem *menuItem;

@end
