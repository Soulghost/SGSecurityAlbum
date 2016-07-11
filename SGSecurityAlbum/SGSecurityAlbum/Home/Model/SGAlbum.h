//
//  SGAlbum.h
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, SGAlbumType) {
    SGAlbumButtonTypeCommon = 0,
    SGAlbumButtonTypeAddButton
};

@interface SGAlbum : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *coverImageURL;
@property (nonatomic, assign) SGAlbumType type;

@end
