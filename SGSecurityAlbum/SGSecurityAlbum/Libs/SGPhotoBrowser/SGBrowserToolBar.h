//
//  SGBrowserToolBar.h
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBlockToolBar.h"
#import "SGBrowserMainToolBar.h"
#import "SGBrowserSecondToolBar.h"

@interface SGBrowserToolBar : UIView

@property (nonatomic, weak) SGBrowserMainToolBar *mainToolBar;
@property (nonatomic, weak) SGBrowserSecondToolBar *secondToolBar;

@end
