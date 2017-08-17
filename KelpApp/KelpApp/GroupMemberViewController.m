//
//  GroupMemberViewController.m
//  KelpApp
//
//  Created by Brian Green on 5/25/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "GroupMemberCell.h"
#import "OrganismGroupInfo.h"
#import "OrganismInfo.h"
#import "OrganismViewController.h"
#import "UINavigationController_rotation.h"


@interface GroupMemberViewController ()

@end

@implementation GroupMemberViewController

@synthesize groupInfo;
@synthesize subGroups;


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
 
    //[self.tableView registerClass:[GroupMemberCell class] forCellReuseIdentifier:@"GroupMemberCellX"];
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setGroupInfo:(OrganismGroupInfo *)info
{
    
    groupInfo = info;
    
    [self.navigationItem setTitle:[info name]];

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
    if ( subGroups != nil ) {
        return [subGroups count];
    }
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( subGroups != nil ) {
        OrganismGroupInfo *info = [subGroups objectAtIndex:section];
        if (info != nil ) {
            return [[info members] count];
        }
        return 0;
    }
    // Return the number of rows in the section.
    return [[groupInfo members] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupMemberCellX";
    GroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //GroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];// forIndexPath:indexPath];
    
    //if ( cell == nil ) {
    //    cell = [[GroupMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //}
    // Configure the cell...
    OrganismInfo* info = nil;
    
    if ( subGroups != nil ) {
        OrganismGroupInfo *grpInfo = [subGroups objectAtIndex:[indexPath section]];
        info = [[grpInfo members] objectAtIndex:[indexPath row]];
    }
    else {
        info = [[groupInfo members] objectAtIndex:[indexPath row]];
    }
    
    [[cell commonName] setText:[info commonName]];
    [[cell scientificName] setText:[info scientificName]];
    [[cell image] setImage:[info thumbnail]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 24.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    OrganismGroupInfo *info = [subGroups objectAtIndex:section];
    return [info name];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"ShowDetails" ] ) {
        
        OrganismViewController* ovc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if ( subGroups != nil ) {
            OrganismGroupInfo *grpInfo = [subGroups objectAtIndex:[indexPath section]];
            [ovc setOrganismInfo:[[grpInfo members] objectAtIndex:[indexPath row]]];
        }
        else {
            [ovc setOrganismInfo:[[groupInfo members] objectAtIndex:[indexPath row]]];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
