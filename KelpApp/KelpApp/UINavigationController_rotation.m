//
//  UINavigationController_rotation.m
//  KelpApp
//
//  Created by Brian Green on 9/4/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "UINavigationController_rotation.h"

@implementation UINavigationController (Rotation)


- (BOOL)shouldAutorotate
{
    return [[self topViewController] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[self topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    
    return [[self topViewController] preferredInterfaceOrientationForPresentation];
}

@end
