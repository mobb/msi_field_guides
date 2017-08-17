//
//  PagedImageViewController.m
//  KelpApp
//
//  Created by Brian Green on 6/9/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "PagedImageViewController.h"
#import "ImageViewController.h"

@interface PagedImageViewController ()
{
    NSMutableArray *viewControllers;
}

@end

@implementation PagedImageViewController

@synthesize imagePaths;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        //self.dataSource = self;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    UIStoryboard *storyboard = [self storyboard];
    
    viewControllers = [[NSMutableArray alloc] init];
    NSUInteger pageIndex = 0;
    
    for ( NSString* imagePath in imagePaths ) {
        
        ImageViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"IVC"];
        [ivc setImagePath:imagePath];
        [ivc setPageIndex:pageIndex++];
        [viewControllers addObject:ivc];
    }
    
    ImageViewController *xivc = [viewControllers objectAtIndex:0];    
    [self setViewControllers:@[xivc] 
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:NULL];

    [self setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (ImageViewController*)viewControllerForPage:
{
    
}
*/
#pragma mark PageView Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(ImageViewController *)vc
{
    if ( vc.pageIndex == 0 ) {
        return nil;
        
    }
    NSUInteger index = vc.pageIndex - 1;
    
    return [viewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(ImageViewController *)vc
{
    NSUInteger index = vc.pageIndex + 1;
    
    if ( index < [viewControllers count] ) {
        return [viewControllers objectAtIndex:index];
    }
    return nil;
}

#pragma mark page view delegate


@end
