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
