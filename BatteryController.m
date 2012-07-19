//
//  BatteryController.m
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "BatteryController.h"

@implementation BatteryController

@synthesize batteryView;

- (void)awakeFromNib;
{
	UIDevice *device = [UIDevice currentDevice];
	device.batteryMonitoringEnabled = YES;
	
	if(NO == device.batteryMonitoringEnabled)
	{
		self.batteryView.batteryState = UIDeviceBatteryStateUnknown;
		return;
	}
	
	self.batteryView.batteryLevel = device.batteryLevel;
	self.batteryView.batteryState = device.batteryState;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateBatteryView:)
												 name:UIDeviceBatteryLevelDidChangeNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateBatteryView:)
												 name:UIDeviceBatteryStateDidChangeNotification
											   object:nil];
}

- (void)dealloc;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.batteryView = nil;
	[super dealloc];
}

-(void)updateBatteryView:(NSNotification *)not;
{
	UIDevice *device = [UIDevice currentDevice];
	
	self.batteryView.batteryLevel = device.batteryLevel;
	self.batteryView.batteryState = device.batteryState;
}

@end
