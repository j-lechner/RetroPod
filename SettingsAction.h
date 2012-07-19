//
//  SettingsAction.h
//  Pod
//
//  Created by Johannes Lechner on 04.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Action.h"
#import "Settings.h"

@interface SettingsAction : Action {
	Setting setting;
	Settings *settings;
}

@property (assign) Setting setting;
@property (retain) Settings *settings;

+ (SettingsAction *)actionForSetting:(Setting)se inSettings:(Settings *)ss;

- (NSString *)currentSetting;
- (void)changeSetting;

@end
