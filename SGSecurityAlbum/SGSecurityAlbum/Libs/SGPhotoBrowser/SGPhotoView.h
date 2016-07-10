//
//  SGPhotoView.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGPhotoModel;
@class SGPhotoBrowser;
@class SGPhotoViewController;

typedef void(^SGPhotoViewTapHandlerBlcok)(void);

@interface SGPhotoView : UIScrollView

@property (nonatomic, weak) SGPhotoViewController *controller;
@property (nonatomic, weak) SGPhotoBrowser *browser;
@property (nonatomic, assign) NSInteger index;

- (void)setSingleTapHandlerBlock:(SGPhotoViewTapHandlerBlcok)handler;

@end
