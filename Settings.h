//
//  Settings.h
//  Pod
//
//  Created by Johannes Lechner on 10.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SettingsAction;

typedef enum {
	SettingShuffle,
	SettingRepeat,
	SettingClicker
} Setting;

@interface Settings : NSObject {

}
@property (assign,setter=setEngravingText:,getter=engravingText) NSString *engravingText;

+ (Settings *)currentSettings;

- (SettingsAction *)shuffleAction;
- (SettingsAction *)repeatAction;
- (SettingsAction *)clickerAction;

- (void)changeSetting:(Setting)s;
- (NSString *)currentSetting:(Setting)s;

@end
