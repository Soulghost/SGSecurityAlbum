//
//  SGPhotoBrowserViewController.h
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "MWPhotoBrowser.h"

@interface SGPhotoBrowserViewController : MWPhotoBrowser <MWPhotoBrowserDelegate>

@property (nonatomic, copy) NSString *rootPath;

@end
