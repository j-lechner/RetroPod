//
//  PodAppDelegate.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright Fudgy Software 2009. All rights reserved.
//

#import "PodAppDelegate.h"
#import "PodViewController.h"

@implementation PodAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	application.statusBarHidden = YES;
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
