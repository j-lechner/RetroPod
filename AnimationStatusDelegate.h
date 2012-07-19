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
