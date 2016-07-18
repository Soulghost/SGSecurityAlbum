//
//  SGPhotoView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoView.h"
#import "SGPhotoModel.h"
#import "UIImageView+WebCache.h"
#import "SGPhotoBrowser.h"
#import "SGPhotoModel.h"
#import "SGZoomingImageView.h"
#import "SGPhotoViewController.h"

@interface SGPhotoView () <UIScrollViewDelegate> {
    CGFloat _pageW;
}

@property (nonatomic, copy) SGPhotoViewTapHandlerBlcok singleTapHandler;
@property (nonatomic, strong) NSArray<SGZoomingImageView *> *imageViews;

@end

@implementation SGPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor blackColor];
    self.pagingEnabled = YES;
    self.delegate = self;
}

- (void)handleDoubleTap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.currentImageView toggleState:YES];
}

- (void)setBrowser:(SGPhotoBrowser *)browser {
    _browser = browser;
    NSInteger count = browser.numberOfPhotosHandler();
    CGSize visibleSize = [UIScreen mainScreen].bounds.size;
    NSMutableArray *imageViews = @[].mutableCopy;
    CGFloat imageViewWidth = visibleSize.width + PhotoGutt * 2;
    _pageW = imageViewWidth - PhotoGutt;
    self.contentSize = CGSizeMake(count * imageViewWidth, 0);
    for (NSUInteger i = 0; i < count; i++) {
        SGZoomingImageView *imageView = [SGZoomingImageView new];
        SGPhotoModel *model = self.browser.photoAtIndexHandler(i);
        [imageView.innerImageView sg_setImageWithURL:model.thumbURL];
        imageView.isOrigin = NO;
        CGRect frame = (CGRect){imageViewWidth * i, 0, imageViewWidth, visibleSize.height};
        imageView.frame = CGRectInset(frame, PhotoGutt, 0);
        [imageViews addObject:imageView];
        [self addSubview:imageView];
        [imageView scaleToFitAnimated:NO];
    }
    self.imageViews = imageViews;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    CGSize visibleSize = [UIScreen mainScreen].bounds.size;
    self.contentOffset = CGPointMake(index * (visibleSize.width + PhotoGutt * 2), 0);
    [self loadImageAtIndex:index];
}

- (void)updateNavBarTitleWithIndex:(NSInteger)index {
    self.controller.navigationItem.title = [NSString stringWithFormat:@"%@ Of %@",@(index + 1),@(self.browser.numberOfPhotosHandler())];
}

- (void)loadImageAtIndex:(NSInteger)index {
    [self updateNavBarTitleWithIndex:index];
    NSInteger count = self.browser.numberOfPhotosHandler();
    for (NSInteger i = 0; i < count; i++) {
//        if (labs(i - index) > 2) continue;
        SGPhotoModel *model = self.browser.photoAtIndexHandler(i);
        SGZoomingImageView *imageView = self.imageViews[i];
        if (i == index) {
            self.currentImageView = imageView;
        } else {
            [imageView scaleToFitIfNeededAnimated:NO];
        }
        NSURL *photoURL = model.photoURL;
        NSURL *thumbURL = model.thumbURL;
        if (i >= index - 1 && i <= index + 1) {
            if (imageView.isOrigin) continue;
            [imageView.innerImageView sg_setImageWithURL:photoURL];
            imageView.isOrigin = YES;
            [imageView scaleToFitAnimated:NO];
        } else {
            if (!imageView.isOrigin) continue;
            [imageView.innerImageView sg_setImageWithURL:thumbURL];
            imageView.isOrigin = NO;
            [imageView scaleToFitAnimated:NO];
        }
    }
}

- (void)setCurrentImageView:(SGZoomingImageView *)currentImageView {
    if (_currentImageView != nil) {
        [_currentImageView setSingleTapHandler:nil];
    }
    _currentImageView = currentImageView;
    WS();
    [_currentImageView setSingleTapHandler:^{
        if (weakSelf.singleTapHandler) {
            weakSelf.singleTapHandler();
        }
    }];
}

- (void)setSingleTapHandlerBlock:(SGPhotoViewTapHandlerBlcok)handler {
    self.singleTapHandler = handler;
}

- (SGPhotoModel *)currentPhoto {
    return self.browser.photoAtIndexHandler(_index);
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (offsetX + _pageW * 0.5f) / _pageW;
    if (_index != index) {
        _index = index;
        [self loadImageAtIndex:_index];
    }
}

@end
