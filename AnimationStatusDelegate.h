//
//  AnimationStatusDelegate.h
//  Pod
//
//  Created by Johannes Lechner on 05.07.09.
//  Copyright 2009 Fudgy Software. All rights reserved.
//

@class UIView;

@protocol AnimationStatusDelegate

- (void)viewWillAnimate:(UIView *)view;
- (void)viewDidAnimate:(UIView *)view;

@end
