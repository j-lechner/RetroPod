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
//  PodViewController.h
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright Fudgy Software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollWheelView.h"
#import "DisplayView.h"

#import "Content.h"
#import "Player.h"
#import "Menu.h"
#import "MainMenu.h"
#import "MenuItem.h"
#import "MediaMenuItem.h"
#import "Settings.h"
#import "SettingsMenuItem.h"
#import "MenuController.h"
#import "MenuView.h"
#import "PlayerView.h"

#import "MediaMenu.h"

#import "PlayerController.h"
#import "BatteryController.h"
#import "BackSideController.h"

@interface PodViewController : UIViewController<AnimationStatusDelegate,PlayerControllerDelegate> {
	int animationCounter;

	IBOutlet UIView *frontSideView;
	
	NSMutableArray *contentStack;
	
	PodController *podController;
	
													
	Player *player;
	PlayerView *playerView;
	PlayerController *playerController;

	IBOutlet DisplayView *displayView;
	IBOutlet StatusView *statusView;
	IBOutlet BatteryController *batteryController;
	IBOutlet BackSideController *backsideController;

	MainMenu *mainMenu;
	MenuView *firstMenuView;
	MenuView *secondMenuView;
	MenuController *menuController;
	
	PodController *activeController;
	NSTimer *lastInputTimer;
}

- (void)pushContent:(Content *)content animate:(BOOL)a;
- (void)popContentAnimate:(BOOL)a toRoot:(BOOL)r;

- (IBAction)flipToBackSide:(id)sender;

@end

