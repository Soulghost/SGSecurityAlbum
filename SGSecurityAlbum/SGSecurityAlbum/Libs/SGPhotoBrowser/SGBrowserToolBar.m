//
//  SGBrowserToolBar.m
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGBrowserToolBar.h"

@interface SGBrowserToolBar ()

@end

@implementation SGBrowserToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    SGBrowserMainToolBar *mainToolBar = [[SGBrowserMainToolBar alloc] initWithFrame:self.bounds];
    [self addSubview:mainToolBar];
}

@end
