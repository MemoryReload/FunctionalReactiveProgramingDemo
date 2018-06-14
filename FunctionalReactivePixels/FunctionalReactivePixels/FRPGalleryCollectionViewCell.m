//
//  FRPGalleryCollectionViewCell.m
//  FunctionalReactivePixels
//
//  Created by 何平 on 2018/6/10.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import "FRPGalleryCollectionViewCell.h"
#import "FRPPhotoModel.h"

@interface FRPGalleryCollectionViewCell ()
@property (nonatomic,weak,readwrite) UIImageView* imageView;
@end

@implementation FRPGalleryCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor=[UIColor lightGrayColor];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imgView];
        self.imageView = imgView;
        
        RAC(self.imageView, image) = [[RACObserve(self, model.thumbnailData) filter:^BOOL(id  _Nullable value) {
            return value != nil;
        }] map:^id _Nullable(id  _Nullable value) {
            return [UIImage imageWithData:value];
        }];
    }
    return self;
}

@end
