//
//  SGWelcomeViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGWelcomeViewController.h"
#import "SGWelcomeView.h"

@interface SGWelcomeViewController ()

@property (nonatomic, weak) SGWelcomeView *welcomeView;

@end

@implementation SGWelcomeViewController

- (void)loadView {
    SGWelcomeView *view = [SGWelcomeView new];
    self.view = view;
    self.welcomeView = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
}

@end
