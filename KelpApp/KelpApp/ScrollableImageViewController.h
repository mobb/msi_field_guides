//
//  ScrollableImageViewController.h
//  KelpApp
//
//  Created by Brian Green on 6/8/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollableImageViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableArray* imageViews;
}

@property (nonatomic,strong) NSArray *imagePaths;

@property (weak, nonatomic) IBOutlet UIPageControl *pages;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollArea;

@end
