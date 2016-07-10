//
//  SGPhotoCell.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoCell.h"
#import "SGPhotoModel.h"
#import "UIImageView+WebCache.h"

@interface SGPhotoCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation SGPhotoCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPaht:(NSIndexPath *)indexPath {
    static NSString *ID = @"SGPhotoCell";
    [collectionView registerClass:[SGPhotoCell class] forCellWithReuseIdentifier:ID];
    SGPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)setModel:(SGPhotoModel *)model {
    _model = model;
    NSURL *thumbURL = model.thumbURL;
    if ([thumbURL isFileURL]) {
        self.imageView.image = [UIImage imageWithContentsOfFile:thumbURL.path];
    } else {
        [self.imageView sd_setImageWithURL:thumbURL];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end
