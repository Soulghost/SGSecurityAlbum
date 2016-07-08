//
//  SGWelcomeView.h
//  SGSecurityAlbum
//
//  Created by soulghost on 8/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SGWelcomeBlock)(SGAccount *account);

@interface SGWelcomeView : UIView

- (void)setWelcomeHandler:(SGWelcomeBlock)handler;

@end
