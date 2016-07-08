//
//  SGAccount.m
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGAccount.h"

NSString * const kSGAccountId = @"kSGAccountId";
NSString * const kSGAccountPwd = @"kSGAccountPwd";

@implementation SGAccount

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.accountId forKey:kSGAccountId];
    [encoder encodeObject:self.password forKey:kSGAccountPwd];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.accountId = [decoder decodeIntegerForKey:kSGAccountId];
        self.password = [decoder decodeObjectForKey:kSGAccountPwd];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
