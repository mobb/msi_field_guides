//
//  OrganismSelectionDelegate.h
//  KelpApp
//
//  Created by Brian Green on 8/24/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrganismInfo;

@protocol OrganismSelectionDelegate <NSObject>
-(void)selectedOrganism:(OrganismInfo*)organism;
@end
