//
//  SGAccount.h
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAccount : NSObject <NSSecureCoding>

@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, copy) NSString *password;

@end
