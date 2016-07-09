//
//  SGFileUtil.h
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGFileUtil : NSObject

@property (nonatomic, strong) SGAccount *account;
@property (nonatomic, copy, readonly) NSString *rootPath;

+ (instancetype)sharedUtil;
+ (NSString *)getFileNameFromPath:(NSString *)filePath;
+ (void)savePhoto:(UIImage *)image toRootPath:(NSString *)rootPath withName:(NSString *)name;
+ (void)saveThumb:(UIImage *)image toRootPath:(NSString *)rootPath withName:(NSString *)name;
+ (NSString *)photoPathForRootPath:(NSString *)rootPath;
+ (NSString *)thumbPathForRootPath:(NSString *)rootPath;

@end
