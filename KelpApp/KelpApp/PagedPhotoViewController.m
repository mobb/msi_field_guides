//
//  PagedPhotoViewController.m
//  KelpApp
//
//  Created by Brian Green on 6/15/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "PagedPhotoViewController.h"
#import "PhotoPageViewController.h"

@interface PagedPhotoViewController ()

@end

@implementation PagedPhotoViewController

@synthesize photoTitle;

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
    
    if ( [[self photoPaths] count] == 0 ) {
        NSLog(@"PagedPVC - no images]");
        return;
    }
    //NSLog(@"PPVC - [%d] pages]",[[self photoPaths] count]);
    
    // kick things off by making the first page
    PhotoPageViewController *pageZero = [PhotoPageViewController photoPageForIndex:0
                                                                         photoPath:[[self photoPaths] objectAtIndex:0 ]];
    
    self.dataSource = self;
    
    [self setViewControllers:@[pageZero]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:NO
                                completion:NULL];
    
    
    //UIView *myView = [self view];
    [[self view] setFrame:[[self view ] bounds]];

    // should be set the page control?
    
    // if empty, set to some default...
    [self.navigationItem setTitle:photoTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoPageViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    //NSLog(@"vcBefore: requesting[%d]",index-1);
    
    if ( index > 0 ) {
        index--;
        return [PhotoPageViewController photoPageForIndex:index
                                            photoPath:[[self photoPaths] objectAtIndex:index]];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoPageViewController *)vc
{
    NSUInteger index = vc.pageIndex + 1;
    //NSLog(@"vcAfter: requesting[%d]",index);

    if ( index < [[self photoPaths] count]) {
        return [PhotoPageViewController photoPageForIndex:index
                                                photoPath:[[self photoPaths] objectAtIndex:index]];
        
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [[self photoPaths] count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
