//
//  WebPageViewController.h
//  KelpApp
//
//  Created by Brian Green on 9/2/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPageViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityWidget;

@property (nonatomic,strong) NSURLRequest* request;

@end
