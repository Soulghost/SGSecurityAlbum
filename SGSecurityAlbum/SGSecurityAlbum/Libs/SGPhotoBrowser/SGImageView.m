//
//  SGImageView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGImageView.h"

@implementation SGImageView

- (void)scaleToFitAnimated:(BOOL)animated {
    self.state = SGImageViewStateFit;
    UIImage *image = self.image;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    CGSize visibleSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = visibleSize.width / imageW;
    imageW = visibleSize.width;
    imageH = imageH * scale;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bounds = CGRectMake(0, 0, imageW, imageH);
        }];
    } else {
        self.bounds = CGRectMake(0, 0, imageW, imageH);
    }
}

- (void)scaleToOriginSize:(BOOL)animated {
    self.state = SGImageViewStateOrigin;
    UIImage *image = self.image;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bounds = CGRectMake(0, 0, imageW, imageH);
        }];
    } else {
        self.bounds = CGRectMake(0, 0, imageW, imageH);
    }
}

- (void)toggleState:(BOOL)animated {
    if (self.state == SGImageViewStateNone) return;
    if (self.state == SGImageViewStateFit) {
        [self scaleToOriginSize:animated];
    } else {
        [self scaleToFitAnimated:animated];
    }
}

@end
