//
//  DisplayView.h
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StatusView.h"
#import "BatteryView.h"
#import "ContentView.h"

@interface DisplayView : UIView {
	id<AnimationStatusDelegate> delegate;
	
	IBOutlet StatusView *statusView;
	IBOutlet UILabel *headingLabel;
	IBOutlet BatteryView *batteryView;
	
	ContentView *previousContentView;
	ContentView *contentView;
}

@property (assign) id<AnimationStatusDelegate> delegate;

@property (assign,setter=setHeadingText:,getter=headingText) NSString *headingText;

- (void)setContentViewWithAnimation:(ContentView *)view 
							animate:(BOOL)animate 
						   fromLeft:(BOOL)left;

@end
