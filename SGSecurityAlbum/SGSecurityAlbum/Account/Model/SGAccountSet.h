//
//  SGAccountSet.h
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAccountSet : NSObject <NSSecureCoding>

@property (nonatomic, strong) NSMutableDictionary<NSString *, SGAccount *> *accountMap;
@property (nonatomic, copy) NSString *touchIDPassword;

@end
