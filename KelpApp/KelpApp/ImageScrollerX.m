//
//  ImageScrollerX.m
//  KelpApp
//
//  Created by Brian Green on 6/11/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "ImageScrollerX.h"

@interface ImageScrollerX () <UIScrollViewDelegate>
{
    UIImageView *_zoomView;
    CGSize _imageSize;
    
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
    
    
}

@end

@implementation ImageScrollerX 

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
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _zoomView.frame;
    
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
    
    _zoomView.frame = frameToCenter;
    
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomView;
}

- (void)setFrame:(CGRect)frame
{
    BOOL bSizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if ( bSizeChanging ) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (bSizeChanging) {
        [self recoverFromResizing];
    }
}

- (void)setImageName:(NSString *)imageName
{
    
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    UIImage* newImage = [UIImage imageWithContentsOfFile:imagePath];

    [self displayImage:newImage];
}
- (void)setImagePath:(NSString *)imagePath
{
    UIImage* newImage = [UIImage imageWithContentsOfFile:imagePath];
    [self displayImage:newImage];
}


- (void)displayImage:(UIImage*)image
{
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    self.zoomScale = 1.0;
    
    _zoomView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_zoomView];
    
    [self configureForImageSize:[image size]];
    
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
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width  / _imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / _imageSize.height;   // the scale needed to perfectly fit the image height-wise
    
    // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
    BOOL imagePortrait = _imageSize.height > _imageSize.width;
    BOOL phonePortrait = boundsSize.height > boundsSize.width;
    CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}
- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake( CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:_zoomView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    
    if ( _scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON ) {
        _scaleToRestoreAfterResize = 0;
    }
    
}
- (void)recoverFromResizing
{
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // find zoom scale
    CGFloat maxZoomScale = MAX( _scaleToRestoreAfterResize, self.minimumZoomScale );
    maxZoomScale = MIN( maxZoomScale, self.maximumZoomScale );
   
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:_zoomView];
    
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
