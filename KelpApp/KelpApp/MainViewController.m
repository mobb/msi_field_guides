//
//  MainViewController.m
//  KelpApp
//
//  Created by Brian Green on 5/30/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "MainViewController.h"
#import "GroupsViewController.h"
#import "FAQViewController.h"
#import "AboutUsViewController.h"
#import "OrganismDatabase.h"
#import "FAQDatabase.h"
//#import "PagedPhotoViewController.h"
#import "UINavigationController_rotation.h"


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize exploreButton;
@synthesize faqButton;
@synthesize aboutButton;
@synthesize backgroundImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
   
    //CGRect screenSize = [[UIScreen mainScreen] bounds];
    //NSLog(@"screen size[%.2f %.2f]",screenSize.size.width,screenSize.size.height);
    
    //we need to determine
    //CGRect xframe = [self.view frame];
    //NSLog(@"main view frame: origin[%.2f %.2f] size[%.2f %.2f]",xframe.origin.x, xframe.origin.y,xframe.size.width,xframe.size.height);
    
    //xframe = [self.backgroundImage frame];
    //NSLog(@"backgroundImage view frame: origin[%.2f %.2f] size[%.2f %.2f]",xframe.origin.x, xframe.origin.y,xframe.size.width,xframe.size.height);

    //xframe = [self.backgroundImage bounds];
    //NSLog(@"backgroundImage view bounds: origin[%.2f %.2f] size[%.2f %.2f]",xframe.origin.x, xframe.origin.y,xframe.size.width,xframe.size.height);
    

}

- (void)viewDidLayoutSubviews
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    // if this is an iphone 5 (or later?) adjust the layout
    if ( screenSize.size.height == 568 ) {
        
        //@todo these should be calculated on the fly
        CGRect exploreButtonR = [self.exploreButton frame];
        exploreButtonR.origin.y = 302;
        [self.exploreButton setFrame:exploreButtonR];
        
        CGRect faqButtonR = [self.faqButton frame];
        faqButtonR.origin.y = 368;
        [self.faqButton setFrame:faqButtonR];
        
        CGRect aboutButtonR = [self.aboutButton frame];
        aboutButtonR.origin.y = 432;
        [self.aboutButton setFrame:aboutButtonR];
        
        [self.view setNeedsDisplay]; //?
        
        //NSLog(@"adjusting buttons on main");
        //UIImage *bkImage = [self.backgroundImage image];
        //CGSize bkImageSize = [bkImage size];
        
        //do some asepct ratio calculations to determine proper button placement
        //NSLog(@"bkImage size: [%.1f %.1f]",bkImageSize.width,bkImageSize.height);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
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

// pre 6.0 rotation


#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"ShowGroups" ] ) {
        
        GroupsViewController* gvc = [segue destinationViewController];
        OrganismDatabase *database = [OrganismDatabase sharedDatabase];
        [gvc setGroups:[database groups]];
    }
    else if ( [[segue identifier] isEqualToString:@"ShowFAQs" ] ) {
        
        FAQViewController* FAQvc = [segue destinationViewController];
        [FAQvc setFAQs:[[FAQDatabase sharedDatabase] FAQs ]];
    }
    else if ( [[segue identifier] isEqualToString:@"ShowAboutUs" ] ) {
    
    }
    /*
    else if ( [[segue identifier] isEqualToString:@"PhotoTest" ] ) {
        PagedPhotoViewController *ppvc = [segue destinationViewController];
        
        NSMutableArray* paths = [[NSMutableArray alloc] init];
        
        [paths addObject: [[NSBundle mainBundle] pathForResource:@"1_1.png" ofType:nil]];
        [paths addObject: [[NSBundle mainBundle] pathForResource:@"1_2.png" ofType:nil]];
        [paths addObject: [[NSBundle mainBundle] pathForResource:@"2_1.png" ofType:nil]];
        [paths addObject: [[NSBundle mainBundle] pathForResource:@"2_2.png" ofType:nil]];
        
        [ppvc setPhotoPaths:paths];
    }
     */
}
@end
