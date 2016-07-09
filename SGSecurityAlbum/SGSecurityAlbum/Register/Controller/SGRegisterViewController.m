//
//  SGRegisterViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGRegisterViewController.h"
#import "SGRegisterView.h"

@interface SGRegisterViewController ()

@property (nonatomic, weak) SGRegisterView *registerView;

@end

@implementation SGRegisterViewController

- (void)loadView {
    SGRegisterView *view = [SGRegisterView new];
    self.view = view;
    self.registerView = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Register";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WS();
    [self.registerView setHandler:^(NSString *password, NSString *confirm) {
        [weakSelf handleRegisterWithPassword:password confirm:confirm];
    }];
}

- (void)handleRegisterWithPassword:(NSString *)password confirm:(NSString *)confirm {
    if (![password isEqualToString:confirm]) {
        [MBProgressHUD showError:@"Passwords Do Not Match"];
        return;
    } else if (!password.length) {
        [MBProgressHUD showError:@"Password Cannot be Empty"];
        return;
    }
    SGAccountManager *mgr = [SGAccountManager sharedManager];
    NSString *errorMessage = nil;
    [mgr registerAccountWithPassword:password errorMessage:&errorMessage];
    if (errorMessage == nil) {
        [MBProgressHUD showSuccess:@"Register Succeeded"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [MBProgressHUD showError:errorMessage];
    }
}

@end
