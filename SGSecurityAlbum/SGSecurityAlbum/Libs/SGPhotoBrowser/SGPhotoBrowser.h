//
//  SGPhotoBrowserViewController.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPhotoModel.h"

typedef SGPhotoModel * (^SGPhotoBrowserDataSourcePhotoBlock)(NSInteger index);
typedef NSInteger (^SGPhotoBrowserDataSourceNumberBlock)(void);

@interface SGPhotoBrowser : UIViewController

@property (nonatomic, assign) NSInteger numberOfPhotosPerRow;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, copy, readonly) SGPhotoBrowserDataSourceNumberBlock numberOfPhotosHandler;
@property (nonatomic, copy, readonly) SGPhotoBrowserDataSourcePhotoBlock photoAtIndexHandler;

- (void)setNumberOfPhotosBlockHandler:(SGPhotoBrowserDataSourceNumberBlock)handler;
- (void)setphotoAtIndexBlockHandler:(SGPhotoBrowserDataSourcePhotoBlock)handler;
- (void)reloadData;

@end
