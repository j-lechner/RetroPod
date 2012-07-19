//
//  Clicker.h
//  Pod
//
//  Created by Johannes Lechner on 17.08.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Clicker : NSObject {
	SystemSoundID clickSoundID;
	BOOL playbackEnabled;
}
@property (assign,setter=setPlaybackEnabled:,getter=playbackEnabled) BOOL playbackEnabled;

+ (Clicker*)clicker;

- (void)playClick;

@end
