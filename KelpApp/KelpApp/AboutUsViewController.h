//
//  AboutUsViewController.h
//  KelpApp
//
//  Created by Brian Green on 5/27/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
