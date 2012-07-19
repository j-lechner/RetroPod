//
//  SettingsAction.m
//  Pod
//
//  Created by Johannes Lechner on 04.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "SettingsAction.h"

@implementation SettingsAction

@synthesize setting;
@synthesize settings;

+ (SettingsAction *)actionForSetting:(Setting)se inSettings:(Settings *)ss;
{
	SettingsAction *a = [[SettingsAction alloc] init];
	a.setting = se;
	a.settings = ss;
	return [a autorelease];
}

- (void)dealloc;
{
	[super dealloc];
}

- (NSString *)currentSetting;
{
	return [settings currentSetting:setting];
}

- (void)changeSetting;
{
	[settings changeSetting:setting];
}

@end
