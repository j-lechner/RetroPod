//
//  MenuView.m
//  Pod
//
//  Created by Johannes Lechner on 17.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import "MenuView.h"

#define WIDTH_MENU_ITEM		200.0
#define HEIGHT_MENU_ITEM	23.0

@implementation MenuView

@synthesize menu;

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
		return nil;
    }
	
	self.opaque = NO;
	
	itemViews = [[NSMutableArray alloc] initWithCapacity:6];
	
	unsigned int viewCounter = 0;
	for(viewCounter=0;viewCounter<6;viewCounter++)
	{
		CGRect viewFrame = CGRectMake(0.0,
									  (self.frame.size.height - (HEIGHT_MENU_ITEM * 6.0)) + HEIGHT_MENU_ITEM * viewCounter,
									  WIDTH_MENU_ITEM, 
									  HEIGHT_MENU_ITEM);
		
		MenuItemView *itemView= [[MenuItemView alloc] initWithFrame:viewFrame];
		[self addSubview:itemView];
		[itemViews addObject:itemView];
		[itemView release];
	}
	
	showsScrollBar = NO;
	
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextClearRect(context, rect);
	
	if(showsScrollBar)
	{
		CGRect scrollRect = CGRectMake(rect.size.width - 12.0, 
									   0.0, 
									   12.0, 
									   rect.size.height);
		
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
		CGContextFillRect(context, scrollRect);
		
		scrollRect.origin.x += 1.0;
		scrollRect.origin.y += 1.0;
		scrollRect.size.width -= 2.0;
		scrollRect.size.height -= 2.0;
		CGContextClearRect(context, scrollRect);
		
		CGFloat numberOfItems = (CGFloat)[menu.menuItems count];
		CGFloat minScrollerHeight = 2.0;
		CGFloat maxScrollerHeight = scrollRect.size.height - 2.0;
		
		CGFloat scrollerHeight = maxScrollerHeight * 6.0/numberOfItems;
		if(scrollerHeight < minScrollerHeight)
		{
			scrollerHeight = minScrollerHeight;
		}
		
		CGFloat scrollerOffset = (menu.scrollOffset * HEIGHT_MENU_ITEM)/(numberOfItems * HEIGHT_MENU_ITEM);
		scrollerOffset *= maxScrollerHeight;
		
		CGRect scrollerRect = CGRectMake(scrollRect.origin.x + 1.0, 
										 scrollRect.origin.y + 1.0 + scrollerOffset, 
										 scrollRect.size.width - 2.0, 
										 scrollerHeight);
		CGContextFillRect(context, scrollerRect);
	}
}

- (void)dealloc {
	[menu release];
	[itemViews release];
    [super dealloc];
}

- (void)setShowsScrollBar:(BOOL)shows;
{
	showsScrollBar = shows;
	
	unsigned int viewCounter = 0;
	
	for(MenuItemView *itemView in itemViews)
	{
		CGRect viewFrame = CGRectMake(0.0,
									  (self.frame.size.height - (HEIGHT_MENU_ITEM * 6.0)) + HEIGHT_MENU_ITEM * viewCounter,
									  WIDTH_MENU_ITEM, 
									  HEIGHT_MENU_ITEM);

		if(showsScrollBar)
		{
			viewFrame.size.width -= 13.0;
		}
	
		itemView.frame = viewFrame;
		++viewCounter;
	}
	
	[self setNeedsDisplay];
}

- (Menu *)menu
{
	return menu;
}

- (void)setMenu:(Menu *)m;
{
	[m retain];
	[menu release];
	menu = m;
	
	[self setShowsScrollBar:[menu.menuItems count] > 6];
	
	NSArray *visibleItems = [menu visibleMenuItems];
	
	unsigned itemCounter = 0;
	
	for(MenuItemView *itemView in itemViews)
	{
		if([visibleItems count] > itemCounter)
		{
			itemView.menuItem = [visibleItems objectAtIndex:itemCounter];
		}
		else
		{
			itemView.menuItem = nil;
		}
		
		++itemCounter;
	}
}

@end
