//
//  SGAccountSet.m
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGAccountSet.h"

NSString * const kSGAccountSetAccountMap = @"kSGAccountSetAccountMap";
NSString * const kSGAccountSetTouchIDPassword = @"kSGAccountSetTouchIDPassword";

@implementation SGAccountSet

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.accountMap = [decoder decodeObjectForKey:kSGAccountSetAccountMap];
        self.touchIDPassword = [decoder decodeObjectForKey:kSGAccountSetTouchIDPassword];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.accountMap forKey:kSGAccountSetAccountMap];
    [encoder encodeObject:self.touchIDPassword forKey:kSGAccountSetTouchIDPassword];
}

- (NSMutableDictionary<NSString *,SGAccount *> *)accountMap {
    if (_accountMap == nil) {
        _accountMap = @{}.mutableCopy;
    }
    return _accountMap;
}

@end
