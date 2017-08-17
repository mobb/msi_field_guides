//
//  PhotoScrollView.m
//  KelpApp
//
//  Created by Brian Green on 6/15/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "PhotoScrollView.h"
/*
@interface PhotoScrollView () <UIScrollViewDelegate>
{
    UIImageView *zoomView;
    CGSize _imageSize;
    
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
}
@end
*/
@implementation PhotoScrollView

- (UIView*)getZoomView
{
    return zoomView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bouncesZoom = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

- (void)resetScale
{
    self.zoomScale = self.minimumZoomScale;
}

- (void)toggleZoom:(CGPoint)zoomCenter
{
    // we are assuming that the zoom center is already in image coordinates (not scroll view)
    
    // determine if we are zoomed in already...
    if ( self.zoomScale == self.minimumZoomScale ) {
        
        CGFloat newZoomScale = self.zoomScale * 2.5f; //?
        newZoomScale = MIN( newZoomScale, self.maximumZoomScale);
        
        CGSize scrollViewSize = self.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = zoomCenter.x - ( w / 2.0f );
        CGFloat y = zoomCenter.y - ( h / 2.0f );
        
        CGRect rectToZoomTo = CGRectMake(x, y, w, h );
        
        [self zoomToRect:rectToZoomTo animated:YES];
    }
    else {
        
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //NSLog(@"layout subviews...");
    
    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = zoomView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    zoomView.frame = frameToCenter;
}

- (void)configurePhoto:(NSString*)photoPath targetSize:(CGSize)targetSize
{
    _photoPath = photoPath;
    UIImage* newImage = [UIImage imageWithContentsOfFile:photoPath];
    
    [zoomView removeFromSuperview];
    zoomView = nil;
    
    self.zoomScale = 1.0;
    
    zoomView = [[UIImageView alloc] initWithImage:newImage];
    [self addSubview:zoomView];
 
    _imageSize = [newImage size];
    self.contentSize = _imageSize;
    [self setMinMaxZoomScalesForBounds:targetSize];
    
    self.zoomScale = self.minimumZoomScale;

    //NSLog(@"image size[%.1f %1.f]",_imageSize.width, _imageSize.height);
}

/*
- (void)setPhotoPath:(NSString *)photoPath
{
    photoPath = photoPath;
    
    //NSLog(@"PSV - %@",photoPath);
    
    UIImage* newImage = [UIImage imageWithContentsOfFile:photoPath];
    [self displayImage:newImage];
}
*/

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomView;
}


- (void)setFrame:(CGRect)frame
{
    //NSLog(@"setFrame:[%.0fx%.0f]",frame.size.width,frame.size.height);
    
    BOOL bSizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if ( bSizeChanging ) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (bSizeChanging) {
        [self recoverFromResizing];
        
        //self.zoomScale = MAX( self.zoomScale, self.minimumZoomScale);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    //if (navigationController.navigationBarHidden==YES) {
    if (touchPoint.y<50) {
        NSLog(@"touch top");
           // self.navigationController.navigationBarHidden=NO;
           // [self startHideNavBarTimer:3.0];
       // }
    }
}

- (void)configureForImageSize:(CGSize)isize
{
    _imageSize = isize;
    self.contentSize = _imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    
    [self setMinMaxZoomScalesForBounds:boundsSize];
}

- (void)setMinMaxZoomScalesForBounds:(CGSize)bounds
{
    // calculate min/max zoomscale
    CGFloat xScale = bounds.width  / _imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = bounds.height / _imageSize.height;   // the scale needed to perfectly fit the image height-wise
    
    // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
    BOOL imagePortrait = _imageSize.height > _imageSize.width;
    BOOL phonePortrait = bounds.height > bounds.width;
    CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);
    
    // deal with retina displays (zoom
    CGFloat maxScale = 4.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale; // * 2.0;
    self.minimumZoomScale = minScale;
    
    //NSLog(@"bounds[%.0fx%.0f] scale: min[%.2f] max[%.2f]",bounds.width,bounds.height,minScale,maxScale);
}


- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake( CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:zoomView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    
    if ( _scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON ) {
        _scaleToRestoreAfterResize = 0;
    }
    
}

//======================================================================================================================================

- (void)recoverFromResizing
{
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // find zoom scale
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
 
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:zoomView];
    
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
    
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    
    return CGPointMake( contentSize.width - boundsSize.width, contentSize.height - boundsSize.height );
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

@end
