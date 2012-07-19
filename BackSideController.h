//
//  BackSideController.h
//  Pod
//
//  Created by Johannes Lechner on 04.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CapacityView.h"
#import "BacksideView.h"

@protocol BackSideControllerDelegate;

@interface BackSideController : NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate,BacksideViewDelegate> {
	UIViewController *parentController;
	UIView *parentView;
	UIView *viewToFlip;											
	
	BacksideView *backsideView;
	NSTimer *timeoutTimer;
	BOOL activationFinished;
}

- (id)initWithParentController:(UIViewController *)c 
				 forParentView:(UIView *)p 
				 andViewToFlip:(UIView *)f;
- (void)activate;
- (IBAction)takePicture:(id)sender;

@end