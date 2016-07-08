//
//  SGAccountManager.m
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGAccountManager.h"
#import "SGRegisterViewController.h"
#import "SGWelcomeViewController.h"
#import "SGAccountSet.h"

#define AccountPath

@interface SGAccountManager ()

@property (nonatomic, strong) SGAccountSet *accountSet;
@property (nonatomic, copy) NSString *accountPath;

@end

@implementation SGAccountManager

+ (instancetype)sharedManager {
    static SGAccountManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (void)loadAccountSet {
    SGAccountSet *set = [NSKeyedUnarchiver unarchiveObjectWithFile:self.accountPath];
    if (!set) {
        set = [SGAccountSet new];
    }
    _accountSet = set;
}

- (void)saveAccountSet {
    [NSKeyedArchiver archiveRootObject:self.accountSet toFile:self.accountPath];
}

- (BOOL)hasAccount {
    return self.accountSet.accountMap.allKeys.count != 0;
}

- (UIViewController *)getRootViewController {
    if ([self hasAccount]) {
        return [[UINavigationController alloc] initWithRootViewController:[SGWelcomeViewController new]];
    }
    SGWelcomeViewController *welcomeVc = [SGWelcomeViewController new];
    SGRegisterViewController *registerVc = [SGRegisterViewController new];
    UINavigationController *nav = [UINavigationController new];
    nav.viewControllers = @[welcomeVc, registerVc];
    return nav;
}

- (NSString *)encryptString:(NSString *)string {
    return [[[[NSString stringWithFormat:@"allowsad12345%@62232",string] MD5] MD5] MD5];
}

- (void)registerAccountWithPassword:(NSString *)password errorMessage:(NSString * __autoreleasing *)errorMessage {
    NSAssert(password != nil, @"password cannot be nil");
    password = [self encryptString:password];
    SGAccount *account = self.accountSet.accountMap[password];
    if (account != nil) {
        *errorMessage = @"Account Already Exists";
        return;
    }
    account = [SGAccount new];
    NSInteger accountid = self.accountSet.accountMap.allKeys.count + 1;
    account.accountId = accountid;
    account.password = password;
    self.accountSet.accountMap[password] = account;
    if (accountid == 1) {
        self.accountSet.touchIDPassword = password;
    }
    [self saveAccountSet];
}

- (SGAccount *)getAccountByPwd:(NSString *)pwd {
    pwd = [self encryptString:pwd];
    return self.accountSet.accountMap[pwd];
}

- (SGAccount *)getTouchIDAccount {
    NSString *pwd = self.accountSet.touchIDPassword;
    return self.accountSet.accountMap[pwd];
}

#pragma mark Lazyload
- (SGAccountSet *)accountSet {
    if (_accountSet == nil) {
        [self loadAccountSet];
    }
    return _accountSet;
}

- (NSString *)accountPath {
    if (_accountPath == nil) {
        _accountPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.agony"];
    }
    return _accountPath;
}

@end
