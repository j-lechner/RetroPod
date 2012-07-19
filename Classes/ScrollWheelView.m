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
//  ScrollWheelView.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#define DIAMETER_CENTER_BUTTON	67.0
#define DIAMETER_SCROLL_WHEEL	200.0
#define DIAMETER_SCROLL_BUTTONS 255.0


#import "ScrollWheelView.h"


@implementation ScrollWheelView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		isScrolling = NO;
		touchedButton = NoButton;
		initialAngle = 0.0;
    }
    return self;
}


- (CGRect)rectForDiameter:(CGFloat)diameter inRect:(CGRect)rect;
{
	return CGRectMake((rect.size.width/2.0)-diameter/2.0,
					  (rect.size.height/2.0)-diameter/2.0,
					  diameter,
					  diameter);
}

- (void)drawDashInContext:(CGContextRef)context atLocation:(CGPoint)location pressed:(BOOL)p;
{
	CGContextSaveGState(context);
	
	if(p)
	{
		CGContextSetRGBFillColor(context, 0.6, 0.6, 0.6, 1.0);
	}
	else
	{
		CGContextSetRGBFillColor(context, 0.45, 0.45, 0.45, 1.0);
	}
	
	CGContextFillRect(context, CGRectMake(location.x, location.y + 1.0,
										  3.0,
										  12.0));

	CGContextRestoreGState(context);
}

- (void)drawPlayInContext:(CGContextRef)context atLocation:(CGPoint)location mirrowed:(BOOL)m  pressed:(BOOL)p;
{
	CGContextSaveGState(context);

	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, location.x, location.y);
	CGContextAddLineToPoint(context, location.x, location.y+12.0);
	
	if(m)
	{
		CGContextAddLineToPoint(context, location.x-9.0, location.y+6.0);
	}
	else
	{
		CGContextAddLineToPoint(context, location.x+9.0, location.y+6.0);
	}
	
	
	CGContextClosePath(context);
	
	if(p)
	{
		CGContextSetRGBFillColor(context, 0.6, 0.6, 0.6, 1.0);
	}
	else
	{
		CGContextSetRGBFillColor(context, 0.45, 0.45, 0.45, 1.0);
	}
	
	CGContextFillPath(context);
	
	CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);

	CGContextSaveGState(context);
	
	CGFloat middleY = 266.0;
	
	[self drawPlayInContext:context 
				 atLocation:CGPointMake((rect.size.width/2.0)-14.0, 
										middleY+1.0)
				   mirrowed:NO
					pressed:(PlayButton == touchedButton)];
	[self drawDashInContext:context 
				 atLocation:CGPointMake((rect.size.width/2.0)+1.0, 
										middleY)
					pressed:(PlayButton == touchedButton)];
	[self drawDashInContext:context 
				 atLocation:CGPointMake((rect.size.width/2.0+6.0), 
										middleY)
					pressed:(PlayButton == touchedButton)];
	
	CGFloat middleX = 37.0;
	
	[self drawDashInContext:context 
				 atLocation:CGPointMake(middleX, 
										(rect.size.height/2.0)-7.0)
					pressed:(PreviousButton == touchedButton)];
	[self drawPlayInContext:context 
				 atLocation:CGPointMake(middleX+10.0, 
										(rect.size.height/2.0)-6.0)
				   mirrowed:YES
					pressed:(PreviousButton == touchedButton)];
	[self drawPlayInContext:context 
				 atLocation:CGPointMake(middleX+18.0, 
										(rect.size.height/2.0)-6.0)
				   mirrowed:YES
					pressed:(PreviousButton == touchedButton)];
	
	middleX = 264.0;
	
	[self drawPlayInContext:context 
				 atLocation:CGPointMake(middleX, 
										(rect.size.height/2.0)-6.0)
				   mirrowed:NO
					pressed:(NextButton == touchedButton)];
	[self drawPlayInContext:context 
				 atLocation:CGPointMake(middleX+8.0, 
										(rect.size.height/2.0)-6.0)
				   mirrowed:NO
					pressed:(NextButton == touchedButton)];
	[self drawDashInContext:context 
				 atLocation:CGPointMake(middleX+16.0, 
										(rect.size.height/2.0)-7.0)
					pressed:(NextButton == touchedButton)];
	
	CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1, -1);
	
    CGContextSelectFont(context,"Helvetica-Bold",14.0,kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
	
	if(MenuButton == touchedButton)
	{
		CGContextSetRGBFillColor(context, 0.50, 0.50, 0.50, 1.0);
	}
	else
	{
		CGContextSetRGBFillColor(context, 0.35, 0.35, 0.35, 1.0);
	}
	
	CGContextSetTextMatrix(context,CGAffineTransformMakeRotation(M_PI_4/8.0));
    CGContextShowTextAtPoint (context, 143.0, 270.0, "m",1);
	CGContextSetTextMatrix(context,CGAffineTransformMakeRotation(M_PI_4/12.0));
    CGContextShowTextAtPoint (context, 156.0, 271.0, "e",1);
	CGContextSetTextMatrix(context,CGAffineTransformMakeRotation(-M_PI_4/12.0));
    CGContextShowTextAtPoint (context, 164.0, 271.0, "n",1);
	CGContextSetTextMatrix(context,CGAffineTransformMakeRotation(-M_PI_4/8.0));
    CGContextShowTextAtPoint (context, 173.0, 270.0, "u",1);
	
	CGContextRestoreGState(context);

	CGContextSetLineWidth(context, 1.5);
	
	if(NoButton != touchedButton && CenterButton != touchedButton)
	{
		CGContextSaveGState(context);
		
		CGContextBeginPath(context);
		CGContextAddEllipseInRect(context, [self rectForDiameter:DIAMETER_SCROLL_WHEEL 
														  inRect:rect]);
		CGContextAddEllipseInRect(context, [self rectForDiameter:DIAMETER_SCROLL_BUTTONS 
														  inRect:rect]);
		
		CGContextClosePath(context);
		CGContextEOClip(context);
		
		CGContextBeginPath(context);
		
		if(MenuButton == touchedButton || PreviousButton == touchedButton)
		{
			CGContextMoveToPoint(context, 0.0, 0.0);
		}
		else
		{
			CGContextMoveToPoint(context, rect.size.width, rect.size.height);
		}
		
		CGContextAddLineToPoint(context, rect.size.width/2.0,rect.size.height/2.0);
	
		if(MenuButton == touchedButton || NextButton == touchedButton)
		{
			CGContextAddLineToPoint(context, rect.size.width,0.0);
		}
		else
		{
			CGContextAddLineToPoint(context,0.0,rect.size.height);
		}
		
		CGContextClosePath(context);
		
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,0.1);
		CGContextFillPath(context);
		
		CGContextRestoreGState(context);
	}
	
	CGContextSetRGBStrokeColor(context, 0.6, 0.6, 0.6, 1.0);
	CGContextStrokeEllipseInRect(context, [self rectForDiameter:DIAMETER_SCROLL_BUTTONS 
														 inRect:rect]);
	
	CGContextSaveGState(context);
	
	CGContextBeginPath(context);
	CGContextAddEllipseInRect(context, [self rectForDiameter:DIAMETER_SCROLL_BUTTONS 
													  inRect:rect]);
	CGContextAddEllipseInRect(context, [self rectForDiameter:DIAMETER_SCROLL_WHEEL 
													  inRect:rect]);
	CGContextClosePath(context);
	CGContextEOClip(context);
	
	CGPoint topLine[2];
	
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
	
	topLine[0] = CGPointMake(0.0,0.0);
	topLine[1] = CGPointMake(rect.size.width,rect.size.height);
	CGContextStrokeLineSegments(context, topLine, 2);
	
	topLine[0] = CGPointMake(rect.size.width,0.0);
	topLine[1] = CGPointMake(0.0, rect.size.height);
	CGContextStrokeLineSegments(context, topLine, 2);
	
	CGContextRestoreGState(context);

	CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
	
	CGContextStrokeEllipseInRect(context, [self rectForDiameter:DIAMETER_SCROLL_WHEEL 
														 inRect:rect]);
	
	if(CenterButton == touchedButton)
	{
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,0.1);
		CGContextFillEllipseInRect(context, [self rectForDiameter:DIAMETER_CENTER_BUTTON 
															   inRect:rect]);
	}
	
	CGContextStrokeEllipseInRect(context, [self rectForDiameter:DIAMETER_CENTER_BUTTON 
														 inRect:rect]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
	[delegate scrollWheelViewTouched:self];
	
	isScrolling = NO;
	touchedButton = NoButton;
	initialAngle = 0.0;
	
	CGPoint centerPoint = CGPointMake(self.frame.size.width / 2.0,
									  self.frame.size.height / 2.0);
	
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	CGFloat xDelta = touchLocation.x - centerPoint.x;
	CGFloat yDelta = touchLocation.y - centerPoint.y;
	double distance = sqrt(xDelta * xDelta + yDelta * yDelta);	
	
	double radians = atan2(centerPoint.y - touchLocation.y,xDelta);
	double degrees = radians * 180.0 / M_PI;
	
	if(degrees <= 0.0)
	{
		degrees = 360.0 + degrees;
	}
	
	degrees = 360 - degrees;
	initialAngle = degrees;

	if(distance < DIAMETER_CENTER_BUTTON/2.0)
	{
		touchedButton = CenterButton;
		[delegate scrollWheelView:self didPressButton:touchedButton];
	}
	
	else if(distance < DIAMETER_SCROLL_WHEEL/2.0)
	{
		isScrolling = YES;
		initialAngle = degrees;
	}
	
	else if(distance < (DIAMETER_SCROLL_BUTTONS + 60.0)/2.0 ||
			((centerPoint.y - (DIAMETER_SCROLL_WHEEL/2.0) >= touchLocation.y &&
			  centerPoint.y + (DIAMETER_SCROLL_WHEEL/2.0) <= touchLocation.y) &&
			 (centerPoint.x - (DIAMETER_SCROLL_WHEEL/2.0) >= touchLocation.x &&
			  centerPoint.x + (DIAMETER_SCROLL_WHEEL/2.0) <= touchLocation.x)))
	{
		if(degrees >= 45.0 && degrees < 135.0)
		{
			touchedButton = PlayButton;
		}
		else if(degrees >= 135.0 && degrees < 215.0)
		{
			touchedButton = PreviousButton;
		}
		else if(degrees >= 215.0 && degrees < 305.0)
		{
			touchedButton = MenuButton;
		}
		else
		{
			touchedButton = NextButton;
		}
		
		[delegate scrollWheelView:self didPressButton:touchedButton];
	}
	
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
	CGPoint centerPoint = CGPointMake(self.frame.size.width / 2.0,
									  self.frame.size.height / 2.0);
	
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	CGFloat xDelta = touchLocation.x - centerPoint.x;
//	CGFloat yDelta = touchLocation.y - centerPoint.y;
//	double distance = sqrt(xDelta * xDelta + yDelta * yDelta);	
	
	double radians = atan2(centerPoint.y - touchLocation.y,xDelta);
	double degrees = radians * 180.0 / M_PI;
	
	if(degrees <= 0.0)
	{
		degrees = 360.0 + degrees;
	}
	
	degrees = 360 - degrees;
	
	if(isScrolling)
	{
		double delta = degrees - initialAngle;

		if(initialAngle > 270.0 && initialAngle <= 360.0)
		{
			if(degrees >= 0.0 && degrees < 90.0)
			{
				delta = 360.0 - initialAngle + degrees;
			}
		}
		
		if(initialAngle >= 0.0 && initialAngle < 90.0)
		{
			if(degrees > 270.0 && degrees <= 360.0)
			{
				delta = -((360.0 - degrees) + initialAngle);
			}
		}
		
		if(delta > 18.0)
		{
			[delegate scrollWheelViewDidScrollRight:self withTimestamp:touch.timestamp];
			initialAngle = degrees;
		}
		
		if(delta < -18.0)
		{
			[delegate scrollWheelViewDidScrollLeft:self withTimestamp:touch.timestamp];
			initialAngle = degrees;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	isScrolling = NO;
	[delegate scrollWheelView:self didReleaseButton:touchedButton];
	[delegate scrollWheelViewReleased:self];
	touchedButton = NoButton;
	[self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
	isScrolling = NO;
	touchedButton = NoButton;
	[self setNeedsDisplay];
}

- (void)dealloc
{
    [super dealloc];
}


@end
