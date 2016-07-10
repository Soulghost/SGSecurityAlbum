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

- (void)loadView {
    SGPhotoView *view = [SGPhotoView new];
    view.controller = self;
    self.view = view;
    self.photoView = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    WS();
    [self.photoView setSingleTapHandlerBlock:^{
        [weakSelf toggleBarState];
    }];
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
