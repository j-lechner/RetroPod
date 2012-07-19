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
//  StatusView.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "StatusView.h"


@implementation StatusView

@synthesize status;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextClearRect(context, rect);
	
	CGPoint location = CGPointMake(12.0,4.0);
	
	if(Playing == status)
	{
		CGContextBeginPath(context);
		
		CGContextMoveToPoint(context, location.x, location.y);
		CGContextAddLineToPoint(context, location.x, location.y+11.0);
		CGContextAddLineToPoint(context, location.x+11.0, location.y+5.5);
		
		CGContextClosePath(context);
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,1.0);
		CGContextFillPath(context);
	}
	else if(Paused == status)
	{
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,1.0);
		CGContextFillRect(context,CGRectMake(location.x, location.y,
											 4.0, 11.0));
		CGContextFillRect(context,CGRectMake(location.x + 3.0 + 5.0, location.y,
											 4.0, 11.0));
	}
}


- (void)dealloc {
    [super dealloc];
}

- (Status)status
{
	return status;
}

- (void)setStatus:(Status)s
{
	status = s;
	[self setNeedsDisplay];
}

@end
