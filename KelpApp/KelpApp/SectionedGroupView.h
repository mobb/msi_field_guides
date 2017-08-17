//
//  SectionedGroupView.h
//  KelpApp
//
//  Created by Brian Green on 8/14/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganismSelectionDelegate.h"

@interface SectionedGroupView : UITableViewController
{
    
}
@property (nonatomic, strong) NSArray *subGroups;
@property (nonatomic, assign) id<OrganismSelectionDelegate> delegate;
@end
