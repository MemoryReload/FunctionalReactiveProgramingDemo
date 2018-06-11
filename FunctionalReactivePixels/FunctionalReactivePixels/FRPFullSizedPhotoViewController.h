//
//  FRPFullSizedPhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by Heping on 2018/6/11.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPFullSizedPhotoViewController;

@protocol FRPFullSizedPhotoViewControllerDelegate <NSObject>
@optional
-(void)userDidScroll:(FRPFullSizedPhotoViewController*)viewController toPotoIndex:(NSInteger)index;
@end

@interface FRPFullSizedPhotoViewController : UIViewController
@property (nonatomic,strong,readonly) NSArray* photos;
@property (nonatomic,weak) id<FRPFullSizedPhotoViewControllerDelegate> delegate;
-(instancetype)initWithPhotos:(NSArray*)photos currentPhotoIndex:(NSInteger)index;
@end
