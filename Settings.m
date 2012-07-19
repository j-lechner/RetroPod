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
//  Settings.m
//  Pod
//
//  Created by Johannes Lechner on 10.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "Settings.h"
#import "SettingsAction.h"

#import "Clicker.h"
#import <MediaPlayer/MediaPlayer.h>

#define SETTINGS_ENGRAVING_TEXT @"engravingText"

@implementation Settings

static Settings *sharedSettings = nil;

+ (Settings *)currentSettings
{
    @synchronized(self) {
        if (sharedSettings == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedSettings;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedSettings == nil) {
            sharedSettings = [super allocWithZone:zone];
            return sharedSettings;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (SettingsAction *)shuffleAction;
{
	return [SettingsAction actionForSetting:SettingShuffle inSettings:self];
}

- (SettingsAction *)repeatAction;
{
	return [SettingsAction actionForSetting:SettingRepeat inSettings:self];}

- (SettingsAction *)clickerAction;
{
	return [SettingsAction actionForSetting:SettingClicker inSettings:self];
}

- (void)changeSetting:(Setting)s;
{
	switch (s) {
		case SettingShuffle:
		{
			MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
			switch (player.shuffleMode)
			{
				case MPMusicShuffleModeOff:
					player.shuffleMode = MPMusicShuffleModeSongs;
					return;
				case MPMusicShuffleModeSongs:
					player.shuffleMode = MPMusicShuffleModeAlbums;
					return;
				case MPMusicShuffleModeAlbums:
					player.shuffleMode = MPMusicShuffleModeOff;
					return;
				case MPMusicShuffleModeDefault:
					player.shuffleMode = MPMusicShuffleModeOff;
					return;
			}
		}
			break;
		case SettingRepeat:
		{
			MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
			switch (player.repeatMode)
			{
				case MPMusicRepeatModeNone:
					player.repeatMode = MPMusicRepeatModeOne;
					return;
				case MPMusicRepeatModeOne:
					player.repeatMode = MPMusicRepeatModeAll;
					return;
				case MPMusicRepeatModeAll:
					player.repeatMode = MPMusicRepeatModeNone;
					return;
				case MPMusicRepeatModeDefault:
					player.repeatMode = MPMusicRepeatModeNone;
					return;
			}
		}
			break;
		case SettingClicker:
		{
			[Clicker clicker].playbackEnabled = ![Clicker clicker].playbackEnabled;
		}
			break;
	}
}

- (NSString *)currentSetting:(Setting)s;
{
	switch (s) {
		case SettingShuffle:
		{
			MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
			switch (player.shuffleMode)
			{
				case MPMusicShuffleModeOff:
					return NSLocalizedString(@"MenuSettingsShuffleOff",@"");
				case MPMusicShuffleModeAlbums:
					return NSLocalizedString(@"MenuSettingsShuffleAlbums",@"");
				case MPMusicShuffleModeSongs:
					return NSLocalizedString(@"MenuSettingsShuffleSongs",@"");
				case MPMusicShuffleModeDefault:
					return NSLocalizedString(@"MenuSettingsShuffleIPod",@"");
			}
		}
			break;
		case SettingRepeat:
		{
			MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
			switch (player.repeatMode)
			{
				case MPMusicRepeatModeNone:
					return NSLocalizedString(@"MenuSettingsRepeatOff",@"");
				case MPMusicRepeatModeOne:
					return NSLocalizedString(@"MenuSettingsRepeatOne",@"");
				case MPMusicRepeatModeAll:
					return NSLocalizedString(@"MenuSettingsRepeatAll",@"");
				case MPMusicRepeatModeDefault:
					return NSLocalizedString(@"MenuSettingsRepeatIPod",@"");
			}
		}
			break;
		case SettingClicker:
		{
			return ([Clicker clicker].playbackEnabled) ? 
				NSLocalizedString(@"MenuSettingsClickerOn",@"") 
				: NSLocalizedString(@"MenuSettingsClickerOff",@"");
		}
			break;
	}
	
	return nil;
}

- (void)setEngravingText:(NSString *)e;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:e forKey:SETTINGS_ENGRAVING_TEXT];
}

- (NSString *)engravingText;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *text = [defaults objectForKey:SETTINGS_ENGRAVING_TEXT];
	
	if(nil == text)
	{
		return NSLocalizedString(@"EngravingTextDefault",@"");
	}
	
	return text;
}

@end
