//
//  SGFileUtil.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGFileUtil.h"

@implementation SGFileUtil

+ (instancetype)sharedUtil {
    static SGFileUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSString *)getFileNameFromPath:(NSString *)filePath {
    return [[filePath componentsSeparatedByString:@"/"] lastObject];
}

- (void)setAccount:(SGAccount *)account {
    _account = account;
    _rootPath = [DocumentPath stringByAppendingPathComponent:account.password];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:_rootPath isDirectory:nil]) {
        [mgr createDirectoryAtPath:_rootPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

@end
