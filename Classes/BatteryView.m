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
//  BatteryView.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "BatteryView.h"


@implementation BatteryView

@synthesize batteryState;
@synthesize batteryLevel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (unsigned int)numberOfBars;
{
	if(batteryState == UIDeviceBatteryStateCharging)
	{
		return chargingTimerStep;
	}
	
	if(batteryLevel >= 0.80)
	{
		return 4;
	}
	if(batteryLevel >= 0.60)
	{
		return 3;
	}
	if(batteryLevel >= 0.40)
	{
		return 2;
	}
	if(batteryLevel >= 0.20)
	{
		return 1;
	}

	return 0;
}

- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 7.0, 3.0);
	
	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, 0.0, 0.0);
	CGContextAddLineToPoint(context, 27.0, 0.0);
	CGContextAddLineToPoint(context, 27.0, 5.0);
	CGContextAddLineToPoint(context, 29.0, 5.0);
	CGContextAddLineToPoint(context, 29.0, 9.0);
	CGContextAddLineToPoint(context, 27.0, 9.0);
	CGContextAddLineToPoint(context, 27.0, 13.0);
	CGContextAddLineToPoint(context, 0.0, 13.0);
	
	CGContextClosePath(context);
	
	CGContextSetLineWidth(context, 1.0);
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextStrokePath(context);
	
	if(UIDeviceBatteryStateUnknown == batteryState)
	{
		CGContextRestoreGState(context);
		return;
	}
	
	int numberOfBars = [self numberOfBars];
	int barCounter = 0;
	for(barCounter=0;barCounter<4;barCounter++)
	{
		if(numberOfBars-(barCounter+1) >= 0)
		{
			CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
		}
		else
		{
			CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.20);
		}
		
		CGContextFillRect(context, CGRectMake(2.0 + (barCounter * 5.0) + barCounter, 
											  2.0,
											  5.0,
											  9.0));
	}
	
	if(UIDeviceBatteryStateCharging == batteryState || UIDeviceBatteryStateFull == batteryState)
	{
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
		CGContextFillEllipseInRect(context, CGRectMake(-2.5, 
													   (13.0-2.0)/(5.0/2.0),
													   5.0,
													   5.0));
	}
	
	CGContextRestoreGState(context);
}


- (void)dealloc {
	[chargingTimer invalidate];
    [super dealloc];
}

- (UIDeviceBatteryState)batteryState
{
	return batteryState;
}

- (void)setBatteryState:(UIDeviceBatteryState)state;
{
	batteryState = state;
	
	[chargingTimer invalidate];
	chargingTimer = nil;
	
	if(UIDeviceBatteryStateCharging == batteryState)
	{
		chargingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
														 target:self 
													   selector:@selector(chargingTimer:) 
													   userInfo:nil 
														repeats:YES];
		chargingTimerStep = 0;
	}
	
	[self setNeedsDisplay];
}

- (double)batteryLevel
{
	return batteryLevel;
}

- (void)setBatteryLevel:(double)level;
{
	batteryLevel = level;
	[self setNeedsDisplay];
}

- (void)chargingTimer:(NSTimer*)timer;
{
	if(4 == chargingTimerStep)
	{
		chargingTimerStep = 0;
	}
	else
	{
		++chargingTimerStep;
	}
	[self setNeedsDisplay];
}

@end
