//
//  OrganismDetailViewController.h
//  KelpApp
//
//  Created by Brian Green on 8/24/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganismSelectionDelegate.h"

@interface OrganismDetailViewController : UIViewController <OrganismSelectionDelegate, UISplitViewControllerDelegate>

@property (nonatomic,strong) OrganismInfo* organism;
@end
