//
//  SettingsMenuItem.h
//  Pod
//
//  Created by Johannes Lechner on 04.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MenuItem.h"

#import "SettingsAction.h"

@interface SettingsMenuItem : MenuItem {

}

+ (SettingsMenuItem *)menuItemWithMenuText:(NSString *)menuText
						 andSettingsAction:(SettingsAction *)sa;

@end
