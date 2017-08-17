//
//  GroupsViewController.m
//  KelpApp
//
//  Created by Brian Green on 5/22/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "GroupsViewController.h"
#import "OrganismGroupInfo.h"
#import "GroupsCell.h"
#import "GroupMemberViewController.h"
#import "OrganismViewController.h"
#import "OrganismDatabase.h"
#import "UINavigationController_rotation.h"


@interface GroupsViewController ()

@end

@implementation GroupsViewController

@synthesize groups;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - rotation fun

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupsCell";
    GroupsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    OrganismGroupInfo *groupInfo = [groups objectAtIndex:[indexPath row]];
    
    [[cell groupName] setText:[groupInfo name]];
    [[cell groupImage] setImage:[groupInfo thumbnail]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"ShowGroupMembers" ] ) {

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GroupMemberViewController* gmvc = [segue destinationViewController];
        [gmvc setGroupInfo:[groups objectAtIndex:[indexPath row]]];
    }
    else if ( [[segue identifier] isEqualToString:@"ShowDetail"] ) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OrganismGroupInfo *groupInfo = [groups objectAtIndex:[indexPath row]];
        
        OrganismViewController* ovc = [segue destinationViewController];
        [ovc setOrganismInfo:[[groupInfo members] objectAtIndex:0]];
    }
    else if ( [[segue identifier] isEqualToString:@"ShowGroupList"] ) {
 
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OrganismGroupInfo *groupInfo = [groups objectAtIndex:[indexPath row]];
        
        GroupMemberViewController* gmvc = [segue destinationViewController];
        [gmvc setGroupInfo:groupInfo];
        
        [gmvc setSubGroups:[[OrganismDatabase sharedDatabase] subGroupsInGroup:[groupInfo name]]];
            
    }
    
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    OrganismGroupInfo* groupInfo = [groups objectAtIndex:[indexPath row]];
    if ( [[groupInfo members] count] == 1 ) {
        [self performSegueWithIdentifier:@"ShowDetail" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"ShowGroupList" sender:self];
    }

}

@end
