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
#import "SGImageView.h"
#import "SGPhotoViewController.h"

@interface SGPhotoView () <UIScrollViewDelegate> {
    CGFloat _pageW;
}

@property (nonatomic, copy) SGPhotoViewTapHandlerBlcok singleTapHandler;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) NSArray<SGImageView *> *imageViews;
@property (nonatomic, weak) SGImageView *currentImageView;
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
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [self addGestureRecognizer:pan];
    UIImageView *imageView = [UIImageView new];
    self.imageView = imageView;
    [self insertSubview:imageView atIndex:0];
}

// to escape from single tap and double tap trig together
- (void)handleSingleTap {
    if (self.singleTapHandler) {
        self.singleTapHandler();
    }
}

- (void)handleDoubleTap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.currentImageView toggleState:YES];
}

- (void)setBrowser:(SGPhotoBrowser *)browser {
    _browser = browser;
    NSInteger count = browser.numberOfPhotosHandler();
    CGSize visibleSize = [UIScreen mainScreen].bounds.size;
    _pageW = visibleSize.width;
    self.contentSize = CGSizeMake(count * visibleSize.width, 0);
    NSMutableArray *imageViews = @[].mutableCopy;
    CGFloat offsetX = visibleSize.width * 0.5f;
    CGFloat offsetY = visibleSize.height * 0.5f;
    for (NSUInteger i = 0; i < count; i++) {
        SGImageView *imageView = [SGImageView new];
        imageView.frame = (CGRect){0, 0, visibleSize};
        imageView.center = CGPointMake(offsetX + visibleSize.width * i, offsetY);
        imageView.backgroundColor = RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
        [imageViews addObject:imageView];
        [self insertSubview:imageView atIndex:0];
    }
    self.imageViews = imageViews;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    CGSize visibleSize = [UIScreen mainScreen].bounds.size;
    self.contentOffset = CGPointMake(index * visibleSize.width, 0);
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
        SGImageView *imageView = self.imageViews[i];
        if (i == index) self.currentImageView = imageView;
        if (imageView.image == nil) {
            SGPhotoModel *model = self.browser.photoAtIndexHandler(i);
            NSURL *photoURL = model.photoURL;
            if (![photoURL isFileURL]) {
                [imageView sd_setImageWithURL:photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [imageView scaleToFitAnimated:NO];
                }];
            } else {
                imageView.image = [UIImage imageWithContentsOfFile:photoURL.path];
                [imageView scaleToFitAnimated:NO];
            }
        }
    }
}

//- (void)pan:(UIPanGestureRecognizer *)pan {
//    
//}

- (void)setSingleTapHandlerBlock:(SGPhotoViewTapHandlerBlcok)handler {
    self.singleTapHandler = handler;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:0.2];
            break;
        case 2:
            [self handleDoubleTap];
            break;
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
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
