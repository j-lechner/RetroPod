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
//  MenuItemView.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "MenuItemView.h"


@implementation MenuItemView

@synthesize menuItem;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];

        itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 
															  0.0, 
															  frame.size.width-7.0, 
															  frame.size.height-1.0)];
		itemLabel.opaque = YES;
		itemLabel.backgroundColor = [UIColor clearColor];
		itemLabel.textColor = [UIColor blackColor];
		itemLabel.font = [UIFont boldSystemFontOfSize:16.0];
		[self addSubview:itemLabel];
		
        itemRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 
																   0.0, 
																   frame.size.width-7.0, 
																   frame.size.height-1.0)];
		itemRightLabel.opaque = YES;
		itemRightLabel.backgroundColor = [UIColor clearColor];
		itemRightLabel.textColor = [UIColor blackColor];
		itemRightLabel.font = [UIFont boldSystemFontOfSize:16.0];
		itemRightLabel.textAlignment = UITextAlignmentRight;
		[self addSubview:itemRightLabel];
		
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	
	if(menuItem.showsArrow || menuItem.showsSpeaker)
	{
		if(menuItem.selected)
		{
			CGContextSetRGBFillColor(context,
									 204.0/255.0,
									 201.0/255.0,
									 188.0/255.0,
									 1.0);
			CGContextSetRGBStrokeColor(context,
									   204.0/255.0,
									   201.0/255.0,
									   188.0/255.0,
									   1.0);
		}
		else
		{
			CGContextSetRGBFillColor(context, 0.0,0.0,0.0,1.0);
			CGContextSetRGBStrokeColor(context, 0.0,0.0,0.0,1.0);
		}
		
		if(menuItem.showsArrow)
		{
			CGContextSetLineWidth(context, 2.0);
			
			CGContextBeginPath(context);
			
			CGContextMoveToPoint(context, rect.size.width - 11.0, (rect.size.height/2.0)-(8.0/2.0));
			CGContextAddLineToPoint(context, rect.size.width - 6.0, (rect.size.height/2.0));
			CGContextAddLineToPoint(context, rect.size.width - 11.0, (rect.size.height/2.0)+(8.0/2.0));
			
			CGContextStrokePath(context);
		}
		else if(menuItem.showsSpeaker)
		{
			CGContextFillEllipseInRect(context, CGRectMake(rect.size.width - 13.0,
														   7.0,
														   9.0,
														   9.0));
		}
	}
}

- (void)dealloc {
	[itemLabel release];
	[itemRightLabel release];
	[menuItem release];
    [super dealloc];
}

- (MenuItem *)menuItem
{
	return menuItem;
}

- (void)setMenuItem:(MenuItem *)item;
{
	[item retain];
	[menuItem release];
	menuItem = item;
	
	self.hidden = (nil == item);
	
	CGRect newFrame = CGRectMake(7.0, 
								 0.0, 
								 self.frame.size.width-7.0, 
								 self.frame.size.height-1.0);
	
	if(menuItem.showsArrow || menuItem.showsSpeaker)
	{
		newFrame.size.width -= 17.0;
	}
	
	itemLabel.frame = newFrame;
	newFrame.size.width -= 4.0;
	itemRightLabel.frame = newFrame;
	
	itemLabel.text = menuItem.menuText;
	itemRightLabel.text = menuItem.menuRightText;

	if(menuItem.selected)
	{
		self.backgroundColor = [UIColor blackColor];
		itemLabel.textColor = [UIColor colorWithRed:204.0/255.0
											  green:201.0/255.0
											   blue:188.0/255.0
											  alpha:1.0];
		itemRightLabel.textColor = itemLabel.textColor;
	}
	else
	{
		self.backgroundColor = [UIColor clearColor];
		itemLabel.textColor = [UIColor blackColor];
		itemRightLabel.textColor = itemLabel.textColor;
	}
	
	[self setNeedsDisplay];
}

@end
