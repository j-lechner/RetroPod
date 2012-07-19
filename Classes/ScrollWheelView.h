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
