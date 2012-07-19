//
//  PushMenuAction.h
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "Action.h"
#import "Menu.h"

@interface PushMenuAction : Action {
	Menu *menu;
}

@property (retain) Menu* menu;

+ (PushMenuAction*)actionForMenu:(Menu*)menu;

@end
