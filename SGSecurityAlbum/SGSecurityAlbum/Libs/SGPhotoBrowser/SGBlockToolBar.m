//
//  SGBlockToolBar.m
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGBlockToolBar.h"

@interface SGBlockToolBar ()

@property (nonatomic, copy) SGBlockToolBarActionBlock actionHandler;

@end

@implementation SGBlockToolBar

- (void)setButtonActionHandlerBlock:(SGBlockToolBarActionBlock)handler {
    self.actionHandler = handler;
}

- (void)btnClick:(UIBarButtonItem *)sender {
    if (self.actionHandler) {
        self.actionHandler(sender);
    }
}

@end
