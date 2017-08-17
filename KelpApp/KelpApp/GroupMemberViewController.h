//
//  GroupMemberViewController.h
//  KelpApp
//
//  Created by Brian Green on 5/25/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrganismGroupInfo;

@interface GroupMemberViewController : UITableViewController

@property (nonatomic,strong) OrganismGroupInfo *groupInfo;
@property (nonatomic, strong) NSArray *subGroups;

@end
