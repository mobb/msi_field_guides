//
//  FAQDetailViewController.h
//  KelpApp
//
//  Created by Brian Green on 5/27/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FAQInfo;

@interface FAQDetailViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

- (IBAction)showLargeImage:(id)sender;

@property (nonatomic,strong) FAQInfo* FAQ;

@end
