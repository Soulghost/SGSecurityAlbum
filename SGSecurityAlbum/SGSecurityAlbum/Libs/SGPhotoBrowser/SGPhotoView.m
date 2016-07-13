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
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) NSArray<SGZoomingImageView *> *imageViews;
@property (nonatomic, assign) CGPoint currentImageViewOffset;

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
    UIImageView *imageView = [UIImageView new];
    self.imageView = imageView;
    [self insertSubview:imageView atIndex:0];
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
    _pageW = imageViewWidth;
    self.contentSize = CGSizeMake(count * imageViewWidth, 0);
    for (NSUInteger i = 0; i < count; i++) {
        SGZoomingImageView *imageView = [SGZoomingImageView new];
        CGRect frame = (CGRect){imageViewWidth * i, 0, imageViewWidth, visibleSize.height};
        imageView.frame = CGRectInset(frame, PhotoGutt, 0);
        [imageViews addObject:imageView];
        [self addSubview:imageView];
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
    for (NSInteger i = index - 1; i < count && i <= index + 1; i++) {
        if (i < 0) continue;
        SGZoomingImageView *imageView = self.imageViews[i];
        if (i == index) self.currentImageView = imageView;
        if (imageView.innerImageView.image == nil) {
            SGPhotoModel *model = self.browser.photoAtIndexHandler(i);
            NSURL *photoURL = model.photoURL;
            if (![photoURL isFileURL]) {
                [imageView.innerImageView sd_setImageWithURL:photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [imageView scaleToFitAnimated:NO];
                }];
            } else {
                imageView.innerImageView.image = [UIImage imageWithContentsOfFile:photoURL.path];
                [imageView scaleToFitAnimated:NO];
            }
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (offsetX + _pageW * 0.5f) / _pageW;
    if (_index != index) {
        _index = index;
        [self loadImageAtIndex:_index];
    }
}


@end
