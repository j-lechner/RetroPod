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
