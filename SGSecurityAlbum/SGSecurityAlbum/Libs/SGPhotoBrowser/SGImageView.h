//
//  SGImageView.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SGImageViewState) {
    SGImageViewStateNone = 0,
    SGImageViewStateFit,
    SGImageViewStateOrigin
};

@interface SGImageView : UIImageView

@property (nonatomic, assign) SGImageViewState state;

- (void)scaleToFitAnimated:(BOOL)animated;
- (void)scaleToOriginSize:(BOOL)animated;
- (void)toggleState:(BOOL)animated;

@end
