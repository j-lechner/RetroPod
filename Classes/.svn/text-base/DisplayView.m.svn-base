//
//  DisplayView.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "DisplayView.h"

@implementation DisplayView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if(!(self = [super initWithFrame:frame]))
	{
		return nil;
    }
	
    return self;
}

- (void)dealloc;
{
	[contentView release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect lineRect = CGRectMake(0.0,
								 20.0, 
								 rect.size.width, 
								 1.0);
	
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextFillRect(context, lineRect);
}

- (void)setHeadingText:(NSString *)text
{
	headingLabel.text = text;
}

- (NSString *)headingText;
{
	return headingLabel.text;
}

- (void)setContentViewWithAnimation:(ContentView *)view 
							animate:(BOOL)animate 
						   fromLeft:(BOOL)left;
{
	if(view == contentView)
	{
		return;
	}
	
	if(animate)
	{
		CGRect previousFrame = CGRectMake((left) ? -self.frame.size.width : self.frame.size.width,
										  self.frame.size.height - contentView.frame.size.height, 
										  self.frame.size.width, 
										  contentView.frame.size.height);
		
		CGRect insideFrame = CGRectMake(0.0,
										self.frame.size.height - contentView.frame.size.height, 
										self.frame.size.width, 
										contentView.frame.size.height);

		CGRect outsideFrame = CGRectMake((left) ? self.frame.size.width : -self.frame.size.width,
										 self.frame.size.height - contentView.frame.size.height, 
										 self.frame.size.width, 
										 contentView.frame.size.height);
		
		previousContentView = contentView;
		
		contentView = view;
		[contentView retain];
		contentView.frame = outsideFrame;
		[self addSubview:contentView];
		
		[delegate viewWillAnimate:self];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView setAnimationDuration:0.35];
		
		contentView.frame = insideFrame;
		previousContentView.frame = previousFrame;
		[UIView commitAnimations];
	}
	else
	{
		[contentView removeFromSuperview];
		[contentView release];
		contentView = view;
		[contentView retain];
		
		CGRect newFrame = CGRectMake(0.0,
									 self.frame.size.height - contentView.frame.size.height, 
									 self.frame.size.width, 
									 contentView.frame.size.height);
		contentView.frame = newFrame;
		[self addSubview:contentView];
	}
}

- (void)animationDidStop:(NSString *)animationID 
				finished:(NSNumber *)finished 
				 context:(void *)context;
{
	[previousContentView removeFromSuperview]; 
	[previousContentView release];
	previousContentView = nil;
	
	[delegate viewDidAnimate:self];
}

@end
