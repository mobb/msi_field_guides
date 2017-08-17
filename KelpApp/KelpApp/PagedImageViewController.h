//
//  PagedImageViewController.h
//  KelpApp
//
//  Created by Brian Green on 6/9/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagedImageViewController : UIPageViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic,retain) NSArray *imagePaths;

@end
