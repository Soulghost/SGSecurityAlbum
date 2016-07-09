//
//  SGWelcomeViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "SGWelcomeView.h"
#import "SGWelcomeViewController.h"
#import "SGRegisterViewController.h"
#import "SGHomeViewController.h"
#import "AppDelegate.h"

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStylePlain target:self action:@selector(registerClick)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SGAccountManager  sharedManager].currentAccount = nil;
    [self handleTouchIDLogin];
}

- (void)handleTouchIDLogin {
    LAContext *context = [LAContext new];
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Agony need your Touch ID to login" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                SGAccount *account = [[SGAccountManager sharedManager] getTouchIDAccount];
                [self loginWithAccount:account];
            } else {
                [self handleCommonLogin];
            }
        }];
    } else {
        [self handleCommonLogin];
    }
}

- (void)handleCommonLogin {
    WS();
    [self.welcomeView setWelcomeHandler:^(SGAccount *account) {
        [weakSelf loginWithAccount:account];
    }];
}

- (void)loginWithAccount:(SGAccount *)account {
    if (!account) {
        [MBProgressHUD showError:@"Password Error"];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [SGAccountManager sharedManager].currentAccount = account;
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        app.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[SGHomeViewController new]];
    });
    
}

- (void)registerClick {
    SGRegisterViewController *vc = [SGRegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
