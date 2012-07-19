//
//  Clicker.m
//  Pod
//
//  Created by Johannes Lechner on 17.08.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "Clicker.h"

#define SETTINGS_CLICKER_ENABLED @"clickerEnabled"

@implementation Clicker

static Clicker *clicker = nil;

+ (Clicker*)clicker
{
    @synchronized(self) {
        if (clicker == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return clicker;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (clicker == nil) {
            clicker = [super allocWithZone:zone];
            return clicker;  // assignment and return on first allocation
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

- (id)init;
{
	if(!(self = [super init]))
	{
		return nil;
	}
	
	CFBundleRef mainBundle = CFBundleGetMainBundle();
	CFURLRef clickURL = CFBundleCopyResourceURL(mainBundle,
												CFSTR("Click"),
												CFSTR("caf"),NULL);
	AudioServicesCreateSystemSoundID(clickURL,&clickSoundID);
	CFRelease(clickURL);
	
	return self;
}

- (void)dealloc;
{
	AudioServicesDisposeSystemSoundID(clickSoundID);
	[super dealloc];
}

- (void)playClick;
{
	if(self.playbackEnabled)
	{
		AudioServicesPlaySystemSound(clickSoundID);
	}
}

- (void)setPlaybackEnabled:(BOOL)e;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:e forKey:SETTINGS_CLICKER_ENABLED];
}

- (BOOL)playbackEnabled;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:SETTINGS_CLICKER_ENABLED];
}

@end
