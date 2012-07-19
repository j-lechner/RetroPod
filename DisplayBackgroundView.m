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
//  DisplayBackgroundView.m
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "DisplayBackgroundView.h"


@implementation DisplayBackgroundView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	rect.size.width -= 6.0;
	rect.size.height-= 6.0;
	rect.origin.x += 3.0;
	rect.origin.y += 3.0;
	
	CGFloat radius = 20.0;
	CGFloat fw = CGRectGetWidth(rect) / radius;
	CGFloat fh = CGRectGetHeight(rect) / radius;
	
	CGContextSaveGState(context);

	CGContextBeginPath(context);
	
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextScaleCTM(context, radius, radius);
	
	CGContextMoveToPoint(context, fw, fh/2.0);
	CGContextAddArcToPoint(context, fw, fh, fw/2.0, fh, 0.5);
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2.0, 0.5);
	CGContextAddArcToPoint(context, 0, 0, fw/2.0, 0, 0.5);
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2.0, 0.5);
	
	CGContextClosePath(context);
	
	CGContextRestoreGState(context);
	
	CGContextSetRGBFillColor(context,217.0/255.0,214.0/255.0,200.0/255.0,1.0);
	CGContextFillPath(context);

	radius -= 4.0;
	fw = (CGRectGetWidth(rect) - 3.0) / radius;
	fh = (CGRectGetHeight(rect) - 3.0) / radius;
	
	CGContextSaveGState(context);
	
	CGContextBeginPath(context);
	
	CGContextTranslateCTM(context, CGRectGetMinX(rect)+1.5, CGRectGetMinY(rect)+1.5);
	CGContextScaleCTM(context, radius, radius);
	
	CGContextMoveToPoint(context, fw, fh/2.0);
	CGContextAddArcToPoint(context, fw, fh, fw/2.0, fh, 0.5);
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2.0, 0.5);
	CGContextAddArcToPoint(context, 0, 0, fw/2.0, 0, 0.5);
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2.0, 0.5);
	
	CGContextClosePath(context);
	
	CGContextRestoreGState(context);
	
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.7);
	CGContextStrokePath(context);

	radius = 20.0;
	fw = CGRectGetWidth(rect) / radius;
	fh = CGRectGetHeight(rect) / radius;
	
	CGContextSaveGState(context);
	
	CGContextBeginPath(context);
	
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextScaleCTM(context, radius, radius);
	
	CGContextMoveToPoint(context, fw, fh/2.0);
	CGContextAddArcToPoint(context, fw, fh, fw/2.0, fh, 0.5);
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2.0, 0.5);
	CGContextAddArcToPoint(context, 0, 0, fw/2.0, 0, 0.5);
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2.0, 0.5);
	
	CGContextClosePath(context);
	
	CGContextRestoreGState(context);

	CGContextSetLineWidth(context, 1.5);
	CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 1.0);
	CGContextStrokePath(context);
}


- (void)dealloc {
    [super dealloc];
}


@end
