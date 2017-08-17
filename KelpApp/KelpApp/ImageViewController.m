//
//  ImageViewController.m
//  KelpApp
//
//  Created by Brian Green on 5/29/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize imageArea;
@synthesize imagePath;
@synthesize scrollArea;
@synthesize image;
@synthesize pageIndex;


- (id)initWithImagePath:(NSString*)imPath
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        [self setImagePath:imPath];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (id)initWithFrame:(

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    ////NSString *fileName = [NSString stringWithFormat:@"%@", imageName];
    //NSString* imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil ];//]inDirectory:@"FAQs/images"];
    
    if ( image == nil ) {
        image = [UIImage imageWithContentsOfFile:imagePath];
    }

    [[self imageArea] setImage:image];
    
    [scrollArea setDelegate:self];
    
    //CGSize isize = [image size];
    //NSLog(@"image size[%fx%f]",isize.width,isize.height);

    [scrollArea setContentSize:[image size]];
    [scrollArea setMaximumZoomScale:5.0];
    [scrollArea setMinimumZoomScale:1.0];
    [scrollArea setPagingEnabled:NO];
    [scrollArea setShowsHorizontalScrollIndicator:NO];
    [scrollArea setShowsVerticalScrollIndicator:NO];
    
    [scrollArea setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];

    //[self setView:scrollArea];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    imagePath = nil;
    image = nil;
    
    //imagePaths = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageArea;
}

@end
