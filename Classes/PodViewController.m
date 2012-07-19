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
//  PodViewController.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright Fudgy Software 2009. All rights reserved.
//

#import "PodViewController.h"

#import "ShuffleAllAction.h"
#import "PushMenuAction.h"
#import "PopMenuAction.h"
#import "ShowPlayerAction.h"

@implementation PodViewController



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	backsideController = nil;
	animationCounter = 0;

    [super viewDidLoad];
	
	displayView.delegate = self;

	contentStack = [[NSMutableArray alloc] init];
	
	podController = [[PodController alloc] init];
	
	player = [[Player alloc] init];
	player.headingText = NSLocalizedString(@"MenuNowPlaying",@"");
	playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0.0,0.0,
															  200.0,140.0)];
	playerView.delegate = self;
	playerController = [[PlayerController alloc] initForView:playerView];
	playerController.delegate = self;
	playerController.statusView = statusView;
	
	firstMenuView = [[MenuView alloc] initWithFrame:CGRectMake(0.0,0.0,
															   200.0,140.0)];
	secondMenuView = [[MenuView alloc] initWithFrame:CGRectMake(0.0,0.0,
																200.0,140.0)];
	
	menuController = [[MenuController alloc] init];
	
	
	menuController.parentController = playerController;
	playerController.parentController = podController;

	//Build 'Music' menu
	MediaMenu *playlistsMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery playlistsQuery] 
												 withProperty:MPMediaPlaylistPropertyName];
	MediaMenu *artistsMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery artistsQuery]
											   withProperty:MPMediaItemPropertyArtist];
	MediaMenu *albumsMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery albumsQuery]
											  withProperty:MPMediaItemPropertyAlbumTitle];
//	MediaMenu *songsMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery songsQuery]
//											 withProperty:MPMediaItemPropertyTitle];
	MediaMenu *genresMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery genresQuery]
											  withProperty:MPMediaItemPropertyGenre];
	MediaMenu *composersMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery composersQuery]
												 withProperty:MPMediaItemPropertyComposer];
	MediaMenu *audiobooksMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery audiobooksQuery]
												  withProperty:MPMediaItemPropertyTitle];
	MediaMenu *podcastMenu = [MediaMenu menuForMPMediaQuery:[MPMediaQuery podcastsQuery]
											   withProperty:MPMediaItemPropertyPodcastTitle];
	
	playlistsMenu.headingText	= NSLocalizedString(@"MenuMusicPlaylists",@"");
	artistsMenu.headingText		= NSLocalizedString(@"MenuMusicArtists",@"");
	albumsMenu.headingText		= NSLocalizedString(@"MenuMusicAlbums",@"");
//	songsMenu.headingText		= NSLocalizedString(@"MenuMusicSongs",@"");
	genresMenu.headingText		= NSLocalizedString(@"MenuMusicGenres",@"");
	composersMenu.headingText	= NSLocalizedString(@"MenuMusicComposers",@"");
	audiobooksMenu.headingText	= NSLocalizedString(@"MenuMusicAudiobooks",@"");
	podcastMenu.headingText		= NSLocalizedString(@"MenuMusicPodcasts",@"");
	
	NSArray *musicMenuItems = [NSArray arrayWithObjects:
							   [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuMusicPlaylists",@"")
												  andNextMenu:playlistsMenu],
							   [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuMusicArtists",@"")
												  andNextMenu:artistsMenu],
							   [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuMusicAlbums",@"")
												  andNextMenu:albumsMenu],
//							   [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuMusicSongs",@"")
//												  andNextMenu:songsMenu],
							   [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuMusicGenres",@"")
												  andNextMenu:genresMenu],
							   [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuMusicComposers",@"")
												  andNextMenu:composersMenu],
							   [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuMusicAudiobooks",@"")
												  andNextMenu:audiobooksMenu],
							   [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuMusicPodcasts",@"")
												  andNextMenu:podcastMenu],
							   nil
							   ];
	
	Menu *musicMenu = [[Menu alloc] initWithMenuItems:musicMenuItems];
	musicMenu.headingText = NSLocalizedString(@"MenuMusic",@"");
	
	NSArray *settingsMenuItems = [NSArray arrayWithObjects:
								  [SettingsMenuItem menuItemWithMenuText:NSLocalizedString(@"MenuSettingsShuffle",@"")
													   andSettingsAction:[[Settings currentSettings] shuffleAction]],
								  [SettingsMenuItem menuItemWithMenuText:NSLocalizedString(@"MenuSettingsRepeat",@"")
													   andSettingsAction:[[Settings currentSettings] repeatAction]],
								  [SettingsMenuItem menuItemWithMenuText:NSLocalizedString(@"MenuSettingsClicker",@"") 
													   andSettingsAction:[[Settings currentSettings] clickerAction]],
								  nil
								  ];
	
	Menu *settingsMenu = [[Menu alloc] initWithMenuItems:settingsMenuItems];
	settingsMenu.headingText = NSLocalizedString(@"MenuSettings",@"");
	
	MenuItem *nowPlayingItem = [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuNowPlaying",@"")
													andAction:[ShowPlayerAction action]];
	MenuItem *shuffeItem = [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuShuffleSongs",@"")
												andAction:[ShuffleAllAction action]];
	shuffeItem.showsArrow = NO;
	
	//Build toplevel menu
	NSArray *mainMenuItems = [NSArray arrayWithObjects:
							  [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuMusic",@"") 
												 andNextMenu:musicMenu],
							  [MenuItem menuItemWithMenuText:NSLocalizedString(@"MenuSettings",@"")
												 andNextMenu:settingsMenu],
							  shuffeItem,
							  nowPlayingItem,
							  nil
	];
	
	mainMenu = [[MainMenu alloc] initWithMenuItems:mainMenuItems];
	mainMenu.headingText = NSLocalizedString(@"PodName",@"");
	mainMenu.showsLastItem = !playerController.stopped;
	
	[self pushContent:mainMenu animate:NO];
	
	if(playerController.playing)
	{
		[self pushContent:player animate:NO];
	}
	
	//Prevent volume overlay from appearing
	//See: http://stackoverflow.com/questions/3845222/iphone-sdk-how-to-disable-the-volume-indicator-view-if-the-hardware-buttons-ar
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:
							 CGRectMake(0, 0, 1, 1)] autorelease];
	[self.view addSubview:volumeView]; 
	[self.view sendSubviewToBack:volumeView];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[contentStack release];
	
	[podController release];
	
	[player release];
	[playerView release];
	[playerController release];
	
	[firstMenuView release];
	[secondMenuView release];
	
	[menuController release];
	
	[backsideController release];
	
	[super dealloc];
}

- (void)pushContent:(Content *)content animate:(BOOL)a;
{
	[contentStack addObject:content];
	
	[activeController deactivate];
	
	if([content isKindOfClass:[Player class]])
	{
		[playerController activate];
		activeController = playerController;

		[displayView setContentViewWithAnimation:playerView
										 animate:a 
										fromLeft:YES];
	}
	else if([content isKindOfClass:[Menu class]])
	{
		[menuController activate];
		activeController = menuController;
		
		if(secondMenuView == menuController.menuView)
		{
			menuController.menuView = firstMenuView;
		}
		else
		{
			menuController.menuView = secondMenuView;
		}
		
		menuController.menu = (Menu *)content;
		
		[displayView setContentViewWithAnimation:menuController.menuView
										 animate:a 
										fromLeft:YES];
	}
	
	displayView.headingText = content.headingText;
}

- (void)popContentAnimate:(BOOL)a toRoot:(BOOL)r;
{
	if([contentStack count] <= 1)
	{
		return;
	}
	
	[activeController deactivate];
	
	if(r)
	{
		while([contentStack count] > 1)
		{
			[contentStack removeLastObject];
		}
	}
	else
	{
		[contentStack removeLastObject];
	}
	Content *content = [contentStack lastObject];
	
	if([content isKindOfClass:[Player class]])
	{
		[playerController activate];
		activeController = playerController;

		[displayView setContentViewWithAnimation:playerView
										 animate:a 
										fromLeft:NO];
	}
	else if([content isKindOfClass:[Menu class]])
	{
		[menuController activate];
		activeController = menuController;
		
		if(secondMenuView == menuController.menuView)
		{
			menuController.menuView = firstMenuView;
		}
		else
		{
			menuController.menuView = secondMenuView;
		}
		
		menuController.menu = (Menu *)content;
		
		[displayView setContentViewWithAnimation:menuController.menuView
										 animate:a 
										fromLeft:NO];
	}
	
	displayView.headingText = content.headingText;
}


#pragma mark -
#pragma mark ScrollWheelViewDelegate


- (void)scrollWheelViewDidScrollLeft:(ScrollWheelView*)view withTimestamp:(NSTimeInterval)t;
{
	if(animationCounter != 0)
	{
		return;
	}
	
	[activeController scrolledLeftAtTimestamp:t];
}

- (void)scrollWheelViewDidScrollRight:(ScrollWheelView*)view withTimestamp:(NSTimeInterval)t;
{
	if(animationCounter != 0)
	{
		return;
	}
	
	[activeController scrolledRightAtTimestamp:t];
}

- (void)scrollWheelView:(ScrollWheelView*)view didPressButton:(ScrollWheelButton)button;
{
	if(animationCounter != 0)
	{
		return;
	}
	
	[lastInputTimer invalidate];
	lastInputTimer = nil;

	Action *action = [activeController didPressButton:button];
	
	if([action isKindOfClass:[PushMenuAction class]])
	{
		PushMenuAction *pushAction = (PushMenuAction*)action;
		[self pushContent:pushAction.menu animate:YES];
	}

	if([action isKindOfClass:[ShowPlayerAction class]])
	{
		[self pushContent:player animate:YES];
	}
}

- (void)scrollWheelView:(ScrollWheelView*)view didReleaseButton:(ScrollWheelButton)button;
{
	if(animationCounter != 0)
	{
		return;
	}
	
	Action *action = [activeController didReleaseButton:button];
	
	if([action isKindOfClass:[PushMenuAction class]])
	{
		PushMenuAction *pushAction = (PushMenuAction*)action;
		[self pushContent:pushAction.menu animate:YES];
	}
	
	if([action isKindOfClass:[PopMenuAction class]])
	{
		[self popContentAnimate:YES toRoot:NO];
	}
	
	if([action isKindOfClass:[ShowPlayerAction class]])
	{
		[self pushContent:player animate:YES];
	}
}


- (void)scrollWheelViewTouched:(ScrollWheelView*)view;
{
	[lastInputTimer invalidate];
	lastInputTimer = nil;
}

- (void)scrollWheelViewReleased:(ScrollWheelView*)view;
{
	lastInputTimer = [NSTimer scheduledTimerWithTimeInterval:8.0 
													  target:self
													selector:@selector(inputTimeout:) 
													userInfo:nil 
													 repeats:NO];
	
}

- (void)inputTimeout:(NSTimer *)timer;
{
	lastInputTimer = nil;
	
	if(playerController.playing && activeController != playerController)
	{
		[self pushContent:player animate:YES];
	}
}

#pragma mark -

- (IBAction)flipToBackSide:(id)sender;
{
	if(nil == backsideController)
	{
		backsideController = [[BackSideController alloc] initWithParentController:self
																	forParentView:self.view 
																	andViewToFlip:frontSideView];
	}
	
	[backsideController activate];
}

#pragma mark -
#pragma mark PlayerControllerDelegate

- (void)playerControllerDidStartPlayback:(PlayerController *)c;
{
	mainMenu.showsLastItem = YES;
	menuController.menu = menuController.menu;
}

- (void)playerControllerDidStopPlayback:(PlayerController *)c;
{
	if(activeController == playerController)
	{
		[self popContentAnimate:YES toRoot:YES];
	}
	
	mainMenu.showsLastItem = NO;
	menuController.menu = menuController.menu;
	
	menuController.currentCollection = nil;
	menuController.currentItem = nil;
}

- (void)playerController:(PlayerController *)c didChangeCollection:(MPMediaItemCollection *)col;
{
	menuController.currentCollection = col;
}

- (void)playerController:(PlayerController *)c didChangeItem:(MPMediaItem *)i;
{
	menuController.currentItem = i;
}

#pragma mark -
#pragma mark AnimationStatusDelegate

- (void)viewWillAnimate:(UIView *)view;
{
	++animationCounter;
}

- (void)viewDidAnimate:(UIView *)view;
{
	--animationCounter;
}


@end
