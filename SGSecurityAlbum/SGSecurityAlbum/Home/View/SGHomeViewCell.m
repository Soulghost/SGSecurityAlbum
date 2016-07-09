//
//  SGHomeViewCell.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGHomeViewCell.h"
#import "SGAlbum.h"

@interface SGHomeViewCell ()

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIImageView *thumbImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, strong) MASConstraint *thumbLeftConstraint;
@property (nonatomic, strong) MASConstraint *thumbRightConstraint;
@property (nonatomic, copy) SGHomeViewCellActionBlock actionBlock;

@end

@implementation SGHomeViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"SGHomeViewCell";
    [collectionView registerClass:[SGHomeViewCell class] forCellWithReuseIdentifier:ID];
    SGHomeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIImageView *backgroundImageView = [UIImageView new];
    backgroundImageView.image = [UIImage imageNamed:@"AlbumFolder"];
    [self.contentView addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    UIImageView *thumbImageView = [UIImageView new];
    [self.contentView addSubview:thumbImageView];
    self.thumbImageView = thumbImageView;
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"Default";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(15);
        self.thumbLeftConstraint = make.left.equalTo(self.backgroundImageView.mas_left).offset(20);
        self.thumbRightConstraint = make.right.equalTo(self.backgroundImageView.mas_right).offset(-20);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(0);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-8);
    }];
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
    press.minimumPressDuration = 0.5f;
    [self.contentView addGestureRecognizer:press];
}

- (void)press:(UILongPressGestureRecognizer *)ges {
    if (ges.state != UIGestureRecognizerStateBegan) return;
    if (self.album.type == SGAlbumButtonTypeCommon) {
        if (self.actionBlock) {
            self.actionBlock();
        }
    }
}

- (void)setAlbum:(SGAlbum *)album {
    _album = album;
    if (album.type == SGAlbumButtonTypeAddButton) {
        self.thumbImageView.image = [UIImage imageNamed:@"AlbumAddButton"];
        self.nameLabel.text = @"Add";
    } else {
        UIImage *thumb = [UIImage imageNamed:album.coverImageURL ?: @"AlbumCover_placeholder"];
        self.thumbImageView.image = thumb;
        self.nameLabel.text = album.name;
    }
}

- (void)setAction:(SGHomeViewCellActionBlock)actionBlock {
    _actionBlock = actionBlock;
}

@end
