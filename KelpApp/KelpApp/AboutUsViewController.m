//
//  AboutUsViewController.m
//  KelpApp
//
//  Created by Brian Green on 5/27/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "AboutUsViewController.h"
#import "WebPageViewController.h"
#import "UINavigationController_rotation.h"


@interface AboutUsViewController ()
{
    NSURLRequest *pendingRequest;
    
}

@end

@implementation AboutUsViewController

@synthesize webView;


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

    NSString *filePathString = [[NSBundle mainBundle] pathForResource:@"AboutUs2.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePathString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
    [webView setDelegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma make - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
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
   if ( [[segue identifier] isEqualToString:@"ShowWebPage"] ) {
        
        //[self.navigationItem setTitle:@"Back"];
        
        WebPageViewController *wvc = [segue destinationViewController];
        [wvc setRequest:pendingRequest];
        pendingRequest = nil;
    }
}
@end
