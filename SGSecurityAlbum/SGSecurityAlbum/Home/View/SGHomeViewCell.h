//
//  SGHomeViewCell.h
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGAlbum;

typedef void(^SGHomeViewCellActionBlock)(void);

@interface SGHomeViewCell : UICollectionViewCell

@property (nonatomic, strong) SGAlbum *album;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
- (void)setAction:(SGHomeViewCellActionBlock)actionBlock;

@end
