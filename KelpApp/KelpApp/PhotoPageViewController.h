//
//  PhotoPageViewController.h
//  KelpApp
//
//  Created by Brian Green on 6/15/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPageViewController : UIViewController

+ (PhotoPageViewController*) photoPageForIndex:(NSUInteger) index
                                     photoPath:(NSString*)path;

- (NSUInteger)pageIndex;
//- (void)setPhotoPath:(NSString*)photoPath;


@end
