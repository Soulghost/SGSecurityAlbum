//
//  SGImageView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGZoomingImageView.h"

@interface SGZoomingImageView () <UIScrollViewDelegate> {
    NSTimeInterval _animationDuration;
}

@property (nonatomic, copy) SGZoomingImageViewTapHandlerBlock singleTapHandlerBlock;

@end

@implementation SGZoomingImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.backgroundColor = [UIColor blackColor];
        self.maximumZoomScale = 5.0f;
        self.minimumZoomScale = 1.0f;
        self.showsVerticalScrollIndicator = self.showsHorizontalScrollIndicator = NO;
        UIImageView *imageView = [UIImageView new];
        self.innerImageView = imageView;
        [self addSubview:imageView];
    }
    return self;
}

- (void)scaleToFitAnimated:(BOOL)animated {
    self.state = SGImageViewStateFit;
    _animationDuration = 0.3f;
    UIImage *image = self.innerImageView.image;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    CGSize visibleSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = visibleSize.width / imageW;
    self.maximumZoomScale = MAX(scale, 5.0f);
    imageW = visibleSize.width;
    imageH = imageH * scale;
    void (^ModifyBlock)() = ^{
        self.zoomScale = 1.0f;
        self.contentSize = self.bounds.size;
        CGRect frame = self.innerImageView.frame;
        frame.size.width = imageW;
        frame.size.height = imageH;
        frame.origin.x = (self.contentSize.width - imageW) * 0.5f;
        frame.origin.y = (self.contentSize.height - imageH) * 0.5f;
        self.innerImageView.frame = frame;
    };
    if (animated) {
        [UIView animateWithDuration:_animationDuration animations:^{
            ModifyBlock();
        }];
    } else {
        ModifyBlock();
    }
}

- (void)scaleToOriginSize:(BOOL)animated {
    self.state = SGImageViewStateOrigin;
    UIImage *image = self.innerImageView.image;
    CGFloat imageW = image.size.width;
    void (^ModifyBlock)() = ^{
        self.zoomScale = imageW / self.bounds.size.width;
        self.innerImageView.center = CGPointMake(self.contentSize.width * 0.5f, self.contentSize.height * 0.5f);
        self.contentOffset = CGPointMake((self.contentSize.width - self.bounds.size.width) * 0.5f, (self.contentSize.height - self.bounds.size.height) * 0.5f);
    };
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            ModifyBlock();
        }];
    } else {
        ModifyBlock();
    }
    
}

- (void)toggleState:(BOOL)animated {
    if (self.state == SGImageViewStateNone || self.state == SGImageViewStateFit) {
        [self scaleToOriginSize:animated];
    } else {
        [self scaleToFitAnimated:animated];
    }
}

- (void)setSingleTapHandler:(SGZoomingImageViewTapHandlerBlock)handler {
    self.singleTapHandlerBlock = handler;
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

- (void)handleSingleTap {
    if (self.singleTapHandlerBlock) {
        self.singleTapHandlerBlock();
    }
}

- (void)handleDoubleTap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self toggleState:YES];
}

#pragma mark -
#pragma mark UIScrollView Delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView; {
    return self.innerImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat contentW = MAX(self.innerImageView.frame.size.width, self.bounds.size.width);
    CGFloat contentH = MAX(self.innerImageView.frame.size.height, self.bounds.size.height);
    self.contentSize = CGSizeMake(contentW, contentH);
    self.innerImageView.center = CGPointMake(contentW * 0.5f, contentH * 0.5f);
    self.contentOffset = CGPointMake((contentW - self.bounds.size.width) * 0.5f, (contentH - self.bounds.size.height) * 0.5f);
}

@end
