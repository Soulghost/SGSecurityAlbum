//
//  SGPhotoViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoViewController.h"
#import "SGPhotoView.h"
#import "SGPhotoModel.h"

@interface SGPhotoViewController ()

@property (nonatomic, assign) BOOL isBarHidden;
@property (nonatomic, weak) SGPhotoView *photoView;

@end

@implementation SGPhotoViewController

//- (void)loadView {
//    SGPhotoView *view = [SGPhotoView new];
//    view.controller = self;
//    self.view = view;
//    self.photoView = view;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    WS();
    [self.photoView setSingleTapHandlerBlock:^{
        [weakSelf toggleBarState];
    }];
}

- (void)setupView {
    SGPhotoView *photoView = [SGPhotoView new];
    self.photoView = photoView;
    [self.view addSubview:photoView];
    CGFloat x = -PhotoGutt;
    CGFloat y = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.width + 2 * PhotoGutt;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    self.photoView.frame = CGRectMake(x, y, w, h);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.photoView.browser = self.browser;
    self.photoView.index = self.index;
}

- (void)toggleBarState {
    self.isBarHidden = !self.isBarHidden;
    [self.navigationController setNavigationBarHidden:self.isBarHidden animated:YES];
    [UIView animateWithDuration:0.35 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return self.isBarHidden;
}

@end
