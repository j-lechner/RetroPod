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
