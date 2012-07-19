//
//  CapacityView.h
//  Pod
//
//  Created by Johannes Lechner on 05.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CapacityView : UIView {
	NSString *capacity;
	UILabel *capacityLabel;
}

@property (retain,setter=setCapacity:) NSString *capacity;

@end
