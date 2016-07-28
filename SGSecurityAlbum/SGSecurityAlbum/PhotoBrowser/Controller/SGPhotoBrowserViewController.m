//
//  SGPhotoBrowserViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoBrowserViewController.h"
#import "QBImagePickerController.h"

@interface SGPhotoBrowserViewController () <QBImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray<SGPhotoModel *> *photoModels;

@end

@implementation SGPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self loadFiles];
}

- (void)commonInit {
    self.numberOfPhotosPerRow = 4;
    self.title = [SGFileUtil getFileNameFromPath:self.rootPath];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    WS();
    [self setNumberOfPhotosHandlerBlock:^NSInteger{
        return weakSelf.photoModels.count;
    }];
    [self setphotoAtIndexHandlerBlock:^SGPhotoModel *(NSInteger index) {
        return weakSelf.photoModels[index];
    }];
    [self setReloadHandlerBlock:^{
        [weakSelf loadFiles];
    }];
}

- (void)loadFiles {
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *photoPath = [SGFileUtil photoPathForRootPath:self.rootPath];
    NSString *thumbPath = [SGFileUtil thumbPathForRootPath:self.rootPath];
    NSMutableArray *photoModels = @[].mutableCopy;
    NSArray *fileNames = [mgr contentsOfDirectoryAtPath:photoPath error:nil];
    for (NSUInteger i = 0; i < fileNames.count; i++) {
        NSString *fileName = fileNames[i];
        NSURL *photoURL = [NSURL fileURLWithPath:[photoPath stringByAppendingPathComponent:fileName]];
        NSURL *thumbURL = [NSURL fileURLWithPath:[thumbPath stringByAppendingPathComponent:fileName]];
        SGPhotoModel *model = [SGPhotoModel new];
        model.photoURL = photoURL;
        model.thumbURL = thumbURL;
        [photoModels addObject:model];
    }
    
    NSArray *photoURLs = @[@"http://img0.ph.126.net/PgCjtjY9cStBeK-rugbj_g==/6631715378048606880.jpg",
                           @"http://img2.ph.126.net/MReos71sTqftWSZuXz_boQ==/6631554849350946263.jpg",
                           @"http://img1.ph.126.net/0Pz-IkvpsDr3lqsZGdIO4A==/6631566943978852327.jpg"];
    NSArray *thumbURLs = @[@"http://img2.ph.126.net/q9kJFjtxcHzzJZA5EMaSUg==/6631671397583497919.png",
                           @"http://img1.ph.126.net/9blT0g2-VgAueTagWFARlA==/6631683492211398013.png",
                           @"http://img1.ph.126.net/smEiDh0FuAVQFz3rcQQdrw==/6631691188792792414.png"];
    for (NSUInteger i = 0; i < photoURLs.count; i++) {
        NSURL *photoURL = [NSURL URLWithString:photoURLs[i]];
        NSURL *thumbURL = [NSURL URLWithString:thumbURLs[i]];
        SGPhotoModel *model = [SGPhotoModel new];
        model.photoURL = photoURL;
        model.thumbURL = thumbURL;
        [photoModels addObject:model];
    }
    self.photoModels = photoModels;
    [self reloadData];
}

#pragma mark - UIBarButtonItem Action
- (void)addClick {
    QBImagePickerController *picker = [QBImagePickerController new];
    picker.delegate = self;
    picker.allowsMultipleSelection = YES;
    picker.showsNumberOfSelectedAssets = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - QBImagePickerController Delegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    PHImageRequestOptions *op = [[PHImageRequestOptions alloc] init];
    op.synchronous = YES;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:imagePickerController.view];
    [imagePickerController.view addSubview:hud];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    [hud showAnimated:YES];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    __block  NSInteger progressCount = 0;
    NSMutableArray *importAssets = @[].mutableCopy;
    NSInteger progressSum = assets.count * 2;
    void (^hudProgressBlock)(NSInteger currentProgressCount) = ^(NSInteger progressCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = (double)progressCount / progressSum;
            if (progressCount == progressSum) {
                [imagePickerController dismissViewControllerAnimated:YES completion:nil];
                [hud hideAnimated:YES];
                [self loadFiles];
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [PHAssetChangeRequest deleteAssets:importAssets];
                } completionHandler:nil];
            }
        });
    };
    for (int i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        [importAssets addObject:asset];
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        NSString *fileName = [[NSString stringWithFormat:@"%@%@",dateStr,@(i)] MD5];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage *result, NSDictionary *info) {
                
                [SGFileUtil savePhoto:result toRootPath:self.rootPath withName:fileName];
                hudProgressBlock(++progressCount);
            }];
            [imageManager requestImageForAsset:asset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [SGFileUtil saveThumb:result toRootPath:self.rootPath withName:fileName];
                hudProgressBlock(++progressCount);
            }];
        });
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
