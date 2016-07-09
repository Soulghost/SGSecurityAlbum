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

+ (NSString *)photoPathForRootPath:(NSString *)rootPath {
    return [rootPath stringByAppendingPathComponent:@"Photo"];
}

+ (NSString *)thumbPathForRootPath:(NSString *)rootPath {
    return [rootPath stringByAppendingPathComponent:@"Thumb"];
}

+ (void)savePhoto:(UIImage *)image toRootPath:(NSString *)rootPath withName:(NSString *)name {
    NSData *imageDate = UIImagePNGRepresentation(image);
    rootPath = [self photoPathForRootPath:rootPath];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if(![mgr fileExistsAtPath:rootPath isDirectory:nil]) {
        [mgr createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    rootPath = [rootPath stringByAppendingPathComponent:name];
    [imageDate writeToFile:rootPath atomically:YES];
}

+ (void)saveThumb:(UIImage *)image toRootPath:(NSString *)rootPath withName:(NSString *)name {
    NSData *imageDate = UIImagePNGRepresentation(image);
    rootPath = [self thumbPathForRootPath:rootPath];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if(![mgr fileExistsAtPath:rootPath isDirectory:nil]) {
        [mgr createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    rootPath = [rootPath stringByAppendingPathComponent:name];
    [imageDate writeToFile:rootPath atomically:YES];
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
