//
//  UIImageView+SGExtension.m
//  SGSecurityAlbum
//
//  Created by soulghost on 14/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "UIImageView+SGExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SGExtension)

- (void)sg_setImageWithURL:(NSURL *)url {
    if (![url isFileURL]) {
        [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    } else {
        self.image = [UIImage imageWithContentsOfFile:url.path];
    }
}

@end
