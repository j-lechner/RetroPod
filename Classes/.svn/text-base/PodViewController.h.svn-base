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

