//
//  FRPGalleryCollectionViewCell.h
//  FunctionalReactivePixels
//
//  Created by 何平 on 2018/6/10.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoModel;

@interface FRPGalleryCollectionViewCell : UICollectionViewCell
@property (nonatomic,weak) UIImageView* imageView;
@property (nonatomic,strong) RACDisposable* subscription;
-(void)setPhotoModel:(FRPPhotoModel*)model;
@end
