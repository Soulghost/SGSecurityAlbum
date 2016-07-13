//
//  SGPhotoToolBar.m
//  SGSecurityAlbum
//
//  Created by soulghost on 12/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoToolBar.h"

@interface SGPhotoToolBar ()

@end

@implementation SGPhotoToolBar

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

- (void)setupViews {
    UIBarButtonItem *trashItem = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemTrash];
    trashItem.tag = SGPhotoToolBarTrashTag;
    UIBarButtonItem *exportItem = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemAction];
    exportItem.tag = SGPhotoToolBarExportTag;
    UIBarButtonItem *spring = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemFlexibleSpace];
    self.items = @[trashItem, spring, exportItem];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIView *view in self.subviews) {
            NSLog(@"%@ %@",NSStringFromClass([view class]),NSStringFromCGRect(view.frame));
        }
    });
}

@end
