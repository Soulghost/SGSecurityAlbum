//
//  SGHomeViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGHomeViewController.h"
#import "SGHomeView.h"

@interface SGHomeViewController () <UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (nonatomic, weak) SGHomeView *homeView;

@end

@implementation SGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self loadFiles];
}

- (void)setupView {
    self.title = @"Agony";
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    SGHomeView *view = [[SGHomeView alloc] initWithFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size} collectionViewLayout:layout];
    view.alwaysBounceVertical = YES;
    view.delegate = self;
    WS();
    [view setAction:^{
        [weakSelf loadFiles];
    }];
    self.homeView = view;
    [self.view addSubview:view];
}

- (void)loadFiles {
    SGFileUtil *util = [SGFileUtil sharedUtil];
    NSString *rootPath = util.rootPath;
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSMutableArray<SGAlbum *> *albums = @[].mutableCopy;
    SGAlbum *addBtnAlbum = [SGAlbum new];
    addBtnAlbum.type = SGAlbumButtonTypeAddButton;
    [albums addObject:addBtnAlbum];
    NSArray *fileNames = [mgr contentsOfDirectoryAtPath:rootPath error:nil];
    for (NSUInteger i = 0; i < fileNames.count; i++) {
        NSString *fileName = fileNames[i];
        SGAlbum *album = [SGAlbum new];
        album.name = fileName;
        album.path = [[SGFileUtil sharedUtil].rootPath stringByAppendingPathComponent:fileName];
        [albums addObject:album];
    }
    self.homeView.albums = albums;
    [self.homeView reloadData];
}

#pragma mark UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SGAlbum *album = self.homeView.albums[indexPath.row];
    if (album.type == SGAlbumButtonTypeAddButton) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Folder" message:@"Please enter folder name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    }
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *folderName = [alertView textFieldAtIndex:0].text;
        if (!folderName.length) {
            [MBProgressHUD showError:@"Folder Name Cannot be Empty"];
            return;
        }
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSString *folderPath = [[SGFileUtil sharedUtil].rootPath stringByAppendingPathComponent:folderName];
        if ([mgr fileExistsAtPath:folderPath isDirectory:nil]) {
            [MBProgressHUD showError:@"Folder Exists"];
            return;
        }
        [mgr createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        [self loadFiles];
    }
}

@end
