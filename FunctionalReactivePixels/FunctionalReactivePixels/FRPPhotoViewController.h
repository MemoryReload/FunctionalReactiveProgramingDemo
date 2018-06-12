//
//  FRPPhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by Heping on 2018/6/11.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoModel;

@interface FRPPhotoViewController : UIViewController
@property (nonatomic,assign,readonly) NSUInteger photoIndex;
@property (nonatomic,strong,readonly) FRPPhotoModel* model;
-(instancetype)initWithPhotoModel:(FRPPhotoModel*)model photoIndex:(NSInteger)index;
@end
