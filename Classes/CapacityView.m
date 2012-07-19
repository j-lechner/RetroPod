//
//  CapacityView.m
//  Pod
//
//  Created by Johannes Lechner on 05.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "CapacityView.h"

@implementation CapacityView

@synthesize capacity;

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
	{
		return nil;
    }

	capacityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 
															  0.0,
															  self.frame.size.width,
															  self.frame.size.height)];
	
	capacityLabel.textColor = [UIColor whiteColor];
	capacityLabel.textAlignment = UITextAlignmentCenter;
	capacityLabel.font = [UIFont systemFontOfSize:19.0];
	capacityLabel.backgroundColor = [UIColor clearColor];
	capacityLabel.opaque = NO;
	capacityLabel.text = capacity;
	
	[self addSubview:capacityLabel];
	
    return self;
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	rect.size.width -= 6.0;
	rect.size.height-= 6.0;
	rect.origin.x += 3.0;
	rect.origin.y += 3.0;
	
	CGFloat radius = 8.0;
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
	
	CGContextSetLineWidth(context, 1.5);
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextStrokePath(context);
}

- (void)dealloc {
	[capacity release];
	[capacityLabel release];
	[super dealloc];
}

- (NSString*)capacity
{
	return capacity;
}

- (void)setCapacity:(NSString *)c
{
	[c retain];
	[capacity release];
	capacity = c;
	capacityLabel.text = capacity;
}


@end
