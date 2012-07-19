//
//  MenuItem.h
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Action, Menu;

@interface MenuItem : NSObject {
	NSString *menuText;
	NSString *menuRightText;
	BOOL showsArrow;
	BOOL isPlaying;
	BOOL showsSpeaker;
	BOOL selected;
	Action *action;
}

@property (retain,getter=getMenuText) NSString *menuText;
@property (retain,getter=getMenuRightText) NSString *menuRightText;
@property (assign) BOOL showsArrow;
@property (assign) BOOL showsSpeaker;
@property (assign) BOOL isPlaying;
@property (assign) BOOL selected;
@property (retain) Action *action;

+ (MenuItem *)menuItemWithMenuText:(NSString *)menuText;
+ (MenuItem *)menuItemWithMenuText:(NSString *)menuText andNextMenu:(Menu *)m;
+ (MenuItem *)menuItemWithMenuText:(NSString *)menuText andAction:(Action *)a;

@end
