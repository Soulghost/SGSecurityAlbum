//
//  SGBrowserMainToolBar.m
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGBrowserMainToolBar.h"

@implementation SGBrowserMainToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translucent = YES;
        [self setupViews];
    }
    return self;
}

- (UIBarButtonItem *)createBarButtomItemWithSystemItem:(UIBarButtonSystemItem)systemItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(btnClick:)];
}

- (UIBarButtonItem *)createBarButtomItemWithImage:(UIImage *)image {
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
}

- (UIBarButtonItem *)createSpring {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

- (void)setupViews {
    UIBarButtonItem *editBtn = [self createBarButtomItemWithImage:[UIImage imageNamed:@"EditButton"]];
    self.items = @[editBtn,[self createSpring]];
}

@end
