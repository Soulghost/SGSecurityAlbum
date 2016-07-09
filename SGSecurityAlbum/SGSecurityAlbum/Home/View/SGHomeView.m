//
//  SGHomeView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGHomeView.h"
#import "SGHomeViewCell.h"

@interface SGHomeView () <UICollectionViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) SGAlbum *currentSelectAlbum;
@property (nonatomic, copy) SGHomeViewNeedReloadActionBlock actionBlock;

@end

@implementation SGHomeView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
}

- (void)setAction:(SGHomeViewNeedReloadActionBlock)actionBlock {
    _actionBlock = actionBlock;
}

#pragma mark -
#pragma mark UICollection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SGHomeViewCell *cell = [SGHomeViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    SGAlbum *album = self.albums[indexPath.row];
    cell.album = album;
    WS();
    [cell setAction:^{
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"Operation" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        [ac showInView:self.superview];
        weakSelf.currentSelectAlbum = album;
    }];
    return cell;
}

#pragma mark -
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [[NSFileManager defaultManager] removeItemAtPath:self.currentSelectAlbum.path error:nil];
        if (self.actionBlock) {
            self.actionBlock();
        }
    }
}

@end
