//
//  BacksideView.h
//  Pod
//
//  Created by Johannes Lechner on 09.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CapacityView.h"

@protocol BacksideViewDelegate;

@interface BacksideView : UIView <UITextFieldDelegate> {
	id<BacksideViewDelegate> delegate;
	
	UIImageView *mirrorImageView;
	UIImageView *maskImageView;
	
	UITextField *engravingField;
	UIImageView *beaverImageView;
	
	UILabel *copyrightLabel;
	UILabel *retroPodLabel;
	UIButton *overlayButton;
	CapacityView *capacityView;
}

@property (assign) id<BacksideViewDelegate> delegate;
@property (assign,setter=setControlsEnabled:,getter=controlsEnabled) BOOL controlsEnabled;
@property (readonly) UITextField *engravingField;
@property (readonly) UIImageView *mirrorImageView;
@property (readonly) UIButton *overlayButton;
@property (readonly) CapacityView *capacityView;
@property (assign,readonly) BOOL showsLiveVideo;

@end

@protocol BacksideViewDelegate

- (void)backsideViewWasTouched:(BacksideView *)view;
- (void)backsideViewDidBeginEditingEngraving:(BacksideView *)view;
- (void)backsideViewDidEndEditingEngraving:(BacksideView *)view;

@end
