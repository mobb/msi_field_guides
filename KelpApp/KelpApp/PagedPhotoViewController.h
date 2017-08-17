//
//  PagedPhotoViewController.h
//  KelpApp
//
//  Created by Brian Green on 6/15/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagedPhotoViewController : UIPageViewController <UIPageViewControllerDataSource>

//- (void)setPhotoPaths:(NSArray*)photoPaths;

@property (nonatomic,copy) NSArray *photoPaths;
@property (nonatomic,copy) NSString *photoTitle;
@end
