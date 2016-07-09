//
//  SGHomeView.h
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGAlbum.h"

@class SGHomeView;
typedef void(^SGHomeViewNeedReloadActionBlock)(void);

@interface SGHomeView : UICollectionView

@property (nonatomic, strong) NSArray<SGAlbum *> *albums;

- (void)setAction:(SGHomeViewNeedReloadActionBlock)actionBlock;

@end
