//
//  BatteryController.h
//  Pod
//
//  Created by Johannes Lechner on 18.06.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BatteryView.h"

@interface BatteryController : NSObject {
	BatteryView *batteryView;
}
@property (nonatomic,retain) IBOutlet BatteryView *batteryView;

@end
