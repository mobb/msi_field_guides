//
//  PhotoScrollView.h
//  KelpApp
//
//  Created by Brian Green on 6/15/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView *zoomView;
    CGSize _imageSize;
    
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
    
    BOOL bZoomed;
}

@property (nonatomic,copy) NSString* photoPath; 

- (UIView*)getZoomView;

- (void)configurePhoto:(NSString*)photoPath targetSize:(CGSize)targetSize;

- (void)resetScale;

- (void)toggleZoom:(CGPoint)zoomCenter;

@end
