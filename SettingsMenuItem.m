//
//  SettingsMenuItem.m
//  Pod
//
//  Created by Johannes Lechner on 04.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "SettingsMenuItem.h"


@implementation SettingsMenuItem

+ (SettingsMenuItem *)menuItemWithMenuText:(NSString *)menuText
						 andSettingsAction:(SettingsAction *)a;
{
	SettingsMenuItem *item = [[SettingsMenuItem alloc] init];
	item.menuText = menuText;
	item.menuRightText = nil;
	item.showsArrow = NO;
	item.showsSpeaker = NO;
	item.isPlaying = NO;
	item.action = (a != nil) ? a : nil;
	return [item autorelease];
}

- (NSString *)getMenuRightText;
{
	SettingsAction *sa = (SettingsAction *)action;
	return sa.currentSetting;
}

@end
