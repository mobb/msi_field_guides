//
//  PhotoPageViewController.m
//  KelpApp
//
//  Created by Brian Green on 6/15/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "PhotoPageViewController.h"
#import "PhotoScrollView.h"


@interface PhotoPageViewController ()
{
    
    NSUInteger _pageIndex;
    NSString* _photoPath;
    
    PhotoScrollView *_photoView;
    
    UIBarStyle _barStyle;
}

@end


@implementation PhotoPageViewController



+ (PhotoPageViewController*) photoPageForIndex:(NSUInteger)index
                                     photoPath:(NSString*)path
{
    
    return [[PhotoPageViewController alloc] initWithPageIndexAndPhotoPath:index photoPath:path];
}

- (NSUInteger)pageIndex
{
    return _pageIndex;
}


- (id)initWithPageIndexAndPhotoPath:(NSInteger)pageIndex photoPath:(NSString*)photoPath
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _pageIndex = pageIndex;
        _photoPath = photoPath;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   
    CGSize boundingSize = [[self view] bounds].size;

    _photoView = [[PhotoScrollView alloc] init];
    [_photoView configurePhoto:_photoPath targetSize:boundingSize];
    [_photoView setBackgroundColor:[UIColor blackColor]];
    
    _photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;    
    self.view = _photoView;
 
    
    
    
    [self.navigationController setToolbarHidden:YES animated:YES ];

    //[[self.navigationController navigationBar] setTranslucent:YES ];
    //[[self navigationController] navigationBar] setTintColor:[UIColor al]
    
    
    // @todo this permanently chnanges it...
    _barStyle = [[self.navigationController navigationBar] barStyle];
    
    //[[self.navigationController navigationBar] setBarStyle:UIBarStyleBlackTranslucent ];
    
    [self setWantsFullScreenLayout:YES];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    
    //[self startHideNavBarTimer:3.0 ];
    
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //reset the scale factor of the view
    [_photoView resetScale];
    
    [[self.navigationController navigationBar] setBarStyle:_barStyle ];
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code
        CGPoint touchLoc = [sender locationInView:[_photoView getZoomView]];
        NSLog(@"touch[%.1fx%.1f]",touchLoc.x,touchLoc.y );
        
        [_photoView toggleZoom:touchLoc];
    }
}


- (void)startHideNavBarTimer:(CGFloat)timeToHide
{
    //self.navigationController.navigationBarHidden=NO;
    
    [NSTimer scheduledTimerWithTimeInterval:timeToHide target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

}

-(void)hideNavigationBar
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
//    if ([timer isValid]) {
 //       [timer invalidate];
//        return;
//    }
}


#pragma mark - gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    if (self.navigationController.navigationBarHidden==YES) {
        if (touchPoint.y<50) {
            self.navigationController.navigationBarHidden=NO;
            [self startHideNavBarTimer:3.0];
        }
    }
}

#pragma mark - rotation

/*
- (void)viewWillLayoutSubviews
{
    NSLog(@"viewWillLayoutSubviews");
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ( toInterfaceOrientation == UIInterfaceOrientationPortrait ) {
        NSLog(@"rotating to portrait");
    }
    else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
        NSLog(@"rotating to landscape LEFT");
    }
    else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
        NSLog(@"rotating to landscape RIGHT");
    }
}
*/

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
