//
//  WebPageViewController.m
//  KelpApp
//
//  Created by Brian Green on 9/2/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "WebPageViewController.h"

@interface WebPageViewController ()

@end

@implementation WebPageViewController

@synthesize webView;
@synthesize request;


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
    
    if ( request != nil ) {
        [webView loadRequest:request];
        [webView setDelegate:self];
        
        //do i need to be a delegate?
        
        CGRect frameR = [[self view ]frame];
        //CGRect boundsR = [[self view] bounds];
        
        CGPoint center;
        center.x = frameR.origin.x + ( frameR.size.width / 2.0 );
        center.y = frameR.origin.y + ( frameR.size.height / 2.0 );
        
        CGRect activityR = [[self activityWidget] frame];
        activityR.origin.x = center.x - ( activityR.size.width / 2.0 );
        activityR.origin.y = center.y - ( activityR.size.height / 2.0 );
        [[self activityWidget] setFrame:activityR];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)layoutSubviews
{
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[self activityWidget] hidesWhenStopped];
    [[self activityWidget] startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[self activityWidget] stopAnimating];
}

@end
