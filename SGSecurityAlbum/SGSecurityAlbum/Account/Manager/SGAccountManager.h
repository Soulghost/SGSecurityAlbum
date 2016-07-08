//
//  SGAccountManager.h
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGAccount.h"

@interface SGAccountManager : NSObject

+ (instancetype)sharedManager;
- (void)registerAccountWithPassword:(NSString *)password errorMessage:(NSString * __autoreleasing *)errorMessage;
- (SGAccount *)getAccountByPwd:(NSString *)pwd;
- (SGAccount *)getTouchIDAccount;
- (UIViewController *)getRootViewController;
- (BOOL)hasAccount;

@end
