//
//  FAQDetailViewController.m
//  KelpApp
//
//  Created by Brian Green on 5/27/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "FAQDetailViewController.h"
#import "FAQInfo.h"
#import "ImageViewController.h"
#import "WebPageViewController.h"
#import "UINavigationController_rotation.h"
#import "PagedPhotoViewController.h"


@interface FAQDetailViewController ()
{
    NSURLRequest *pendingRequest;
}
@end

@implementation FAQDetailViewController

@synthesize image;
@synthesize question;
@synthesize webView;
@synthesize scroller;
@synthesize FAQ;


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
    [[self webView] setDelegate:self];
    
    [[self question] setText:[FAQ question]];
    [[self image] setImage:[FAQ image]];
    
    [[self imageButton] setFrame:[[self image] frame]];
    
    
    NSString *filePathString = [[NSBundle mainBundle] pathForResource:[FAQ answerURL] ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePathString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [[self webView] loadRequest:req];
 
    [[self navigationItem] setTitle:[FAQ question]];
}

- (void)dealloc
{
    [[self webView] setDelegate:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - layout

- (void)viewWillLayoutSubviews
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if ( UIDeviceOrientationIsLandscape(deviceOrientation) ) {
        ;//NSLog(@"landscape");
    }
    else if ( UIDeviceOrientationIsPortrait(deviceOrientation) ) {
        ;//NSLog(@"portrait");
        
    }
    
    UIInterfaceOrientation uiOrientation = [[UIApplication sharedApplication] statusBarOrientation ];
    if ( uiOrientation == UIInterfaceOrientationPortrait ) {
        ;//NSLog(@"ui says portrait");
    }
    else if ( UIInterfaceOrientationIsLandscape(uiOrientation)) {
        ;//NSLog(@"Lando!");
    }
}



#pragma make - UIWebViewDelegate


-(void)webViewDidFinishLoad:(UIWebView *)wview
{
    CGSize contentSize = [[wview scrollView] contentSize];
    CGRect wvFrame = [wview frame];
    if ( contentSize.height > wvFrame.size.height ) {
        wvFrame.size.height = contentSize.height;

        [wview setFrame:wvFrame ];
    }
    

    CGSize newSize = CGSizeMake( contentSize.width, contentSize.height + wvFrame.origin.y + 50 );
    [scroller setContentSize: newSize ];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // if the user clicked a link, then we need to launch another page...
    if ( UIWebViewNavigationTypeLinkClicked == navigationType ) {
        
        pendingRequest = request;
        [self performSegueWithIdentifier:@"ShowWebPage" sender:self];

        return NO;
    }
    return YES;
}

#pragma mark - segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"ShowImage" ] ) {
        
        ImageViewController* ivc = [segue destinationViewController];
        
        [ivc setImage:[FAQ image]];
    }
    else if ( [[segue identifier] isEqualToString:@"ShowWebPage"] ) {
        
        [self.navigationItem setTitle:@"Back"];

        WebPageViewController *wvc = [segue destinationViewController];
        [wvc setRequest:pendingRequest];
        pendingRequest = nil;
    }
    else if ( [[segue identifier] isEqualToString:@"ShowPhotoViewer" ] ) {
        
        // little trick to set the text of the "Back" button
        [self.navigationItem setTitle:@"Back"];
        
        //
        PagedPhotoViewController* ppvc = [segue destinationViewController]; 
        NSArray *pathArray = [[NSArray alloc] initWithObjects:[FAQ imagePath], nil];
        [ppvc setPhotoPaths:pathArray];
        [ppvc setPhotoTitle:[FAQ question]];
    }
    
}

- (IBAction)showLargeImage:(id)sender {
    //[self performSegueWithIdentifier:@"ShowImage" sender:self];
    [self performSegueWithIdentifier:@"ShowPhotoViewer" sender:self];
}
@end
