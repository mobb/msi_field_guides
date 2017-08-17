//
//  ImageScrollerX.h
//  KelpApp
//
//  Created by Brian Green on 6/11/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollerX : UIScrollView //<UIScrollViewDelegate>


@property (nonatomic,copy) NSString* imageName;

- (void)setImagePath:(NSString*)imagePath;

@end
