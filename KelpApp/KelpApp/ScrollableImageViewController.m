//
//  ScrollableImageViewController.m
//  KelpApp
//
//  Created by Brian Green on 6/8/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "ScrollableImageViewController.h"
#import "ImageViewController.h"
#import "ImageScrollerX.h"

@interface ScrollableImageViewController ()

@end

@implementation ScrollableImageViewController

@synthesize imagePaths;
@synthesize pages;
@synthesize scrollArea;

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
    
    if ( imageViews == nil ) {
        imageViews = [[NSMutableArray alloc] init];
    }
    
    //[[self scrollArea] setMaximumZoomScale:4];
    //[[self scrollArea] setMinimumZoomScale:1];
    [[self scrollArea] setDelegate:self];
    [[self scrollArea] setShowsHorizontalScrollIndicator:NO];
    [[self scrollArea] setShowsVerticalScrollIndicator:NO];
    [[self scrollArea] setPagingEnabled:YES];
    
    
    
    CGSize scrollAreaSize = [[self scrollArea] frame].size;
    NSLog(@"size[%fx%f]",scrollAreaSize.width,scrollAreaSize.height);
    
    
    //scrollAreaSize.height -= 20;
    int idx = 0;
    
    //UIStoryboard* storyboard = [self storyboard];
    
    for ( NSString* path in imagePaths ) {
 
        CGRect viewFrame;
        viewFrame.origin.x = idx * scrollAreaSize.width;
        viewFrame.origin.y = 0;
        viewFrame.size = scrollAreaSize;
        
 /*
        UIImage *ximage = [UIImage imageWithContentsOfFile:path ];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:ximage];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];

        [[self scrollArea] addSubview:imageView];
        [imageView setFrame:viewFrame];
        
        ++idx;
*/
        //ImageViewController *ivc = [[ImageViewController alloc] init];//WithFrame:viewFrame];
        //[ivc setImagePath:path];
        
        ImageScrollerX* imagex = [[ImageScrollerX alloc] initWithFrame:viewFrame];
        [imagex setImagePath:path];
        [[self scrollArea] addSubview:imagex];
        
        
        /*
        
        ImageViewController *ivcx = [storyboard instantiateViewControllerWithIdentifier:@"IVC"];
        [ivcx setImagePath:path];
        [[ivcx view] setFrame:viewFrame];
        
        [[self scrollArea] addSubview:[ivcx view]];
*/
        NSLog(@"image[%d][%@]",idx,path);
        ++idx;
        
        //[imageViews addObject:ivcx];
    
    }
    
    CGSize contentSize = CGSizeMake( scrollAreaSize.width * idx, scrollAreaSize.height );
    [[self scrollArea] setContentSize:contentSize];
    
    [[self pages] setNumberOfPages: idx];
    [[self pages] setCurrentPage:0];
    
    
/*
    [super viewDidLoad];
    //Put the names of our image files in our array.
    imageArray = [[NSArray alloc] initWithObjects:@"image1.jpg", @"image2.jpg", @"image3.jpg", nil];
    
    for (int i = 0; i < [imageArray count]; i++) {
        //We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        [self.scrollView addSubview:imageView];
    }
    //Set the content size of our scrollview according to the total width of our imageView objects.
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [imageArray count], scrollView.frame.size.height);
*/
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //determine what page we are currently showing...
    
    
    //[scrollView
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
                  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize scrollAreaSize = [[self scrollArea] frame].size;
    NSLog(@"scroll size[%fx%f]",scrollAreaSize.width,scrollAreaSize.height);
 
    CGRect viewR = [[self view] frame];
    CGSize viewSize = viewR.size;
    
    NSLog(@"view size[%fx%f]",viewSize.width,viewSize.height);
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //remove all of the children...
    for ( ImageViewController *ivc in imageViews ) {
        [[ivc view] removeFromSuperview];
    }
    
    imageViews = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //determine where we are and set the
}
@end
