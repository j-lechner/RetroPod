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
//  ScrollWheelView.h
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	NoButton,
	CenterButton,
	NextButton,
	PreviousButton,
	MenuButton,
	PlayButton
} ScrollWheelButton;

@protocol ScrollWheelViewDelegate;

@interface ScrollWheelView : UIView {
	IBOutlet id<ScrollWheelViewDelegate> delegate;

	double initialAngle;
	BOOL isScrolling;
	
	ScrollWheelButton touchedButton;
	
	CGPoint lastTouchLocation;
}

@property (assign) id<ScrollWheelViewDelegate> delegate;

@end

@protocol ScrollWheelViewDelegate

- (void)scrollWheelViewDidScrollLeft:(ScrollWheelView*)view withTimestamp:(NSTimeInterval)t;
- (void)scrollWheelViewDidScrollRight:(ScrollWheelView*)view withTimestamp:(NSTimeInterval)t;

- (void)scrollWheelView:(ScrollWheelView*)view didPressButton:(ScrollWheelButton)button;
- (void)scrollWheelView:(ScrollWheelView*)view didReleaseButton:(ScrollWheelButton)button;

- (void)scrollWheelViewTouched:(ScrollWheelView*)view;
- (void)scrollWheelViewReleased:(ScrollWheelView*)view;

@end
