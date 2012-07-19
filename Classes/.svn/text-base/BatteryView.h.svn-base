//
//  BatteryView.h
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BatteryView : UIView {
	UIDeviceBatteryState batteryState;
	double batteryLevel;
	
	NSTimer *chargingTimer;
	unsigned int chargingTimerStep;
}

@property (assign,setter=setBatteryState:) UIDeviceBatteryState batteryState;
@property (assign,setter=setBatteryLevel:) double batteryLevel;

@end
