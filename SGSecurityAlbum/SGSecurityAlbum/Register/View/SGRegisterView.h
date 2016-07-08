//
//  SGRegisterView.h
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SGRegisterBlock)(NSString *password, NSString *confirm);

@interface SGRegisterView : UIView

- (void)setHandler:(SGRegisterBlock)handler;

@end
