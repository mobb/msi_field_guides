//
//  ImageViewController.h
//  KelpApp
//
//  Created by Brian Green on 5/29/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic,copy) NSString* imagePath;
@property (nonatomic, strong) UIImage* image;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollArea;
@property (weak, nonatomic) IBOutlet UIImageView *imageArea;

@property (nonatomic) NSUInteger pageIndex;

- (id)initWithImagePath:(NSString*)imagePath;

//- (void)initWithFrame:
@end
