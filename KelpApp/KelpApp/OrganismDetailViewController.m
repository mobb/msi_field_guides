//
//  OrganismDetailViewController.m
//  KelpApp
//
//  Created by Brian Green on 8/24/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "OrganismDetailViewController.h"

@interface OrganismDetailViewController ()

@end

@implementation OrganismDetailViewController

@synthesize organism;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedOrganism:(OrganismInfo *)newOrganism
{
    
    [self setOrganism:newOrganism];
}

-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc
{
    NSLog(@"hide ...");
    
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
    NSLog(@"show");
}

@end
