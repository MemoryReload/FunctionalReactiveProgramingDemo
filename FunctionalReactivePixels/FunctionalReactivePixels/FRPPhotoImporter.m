//
//  FRPPhotoImporter.m
//  FunctionalReactivePixels
//
//  Created by 何平 on 2018/6/8.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@implementation FRPPhotoImporter
+(RACSignal*)importPhotos
{
    RACReplaySubject *subject  = [RACReplaySubject subject];
    NSURL *request = [self popularURLRequest];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [subject sendNext:[[[result[@"photos"] rac_sequence] map:^id _Nullable(id  _Nullable value) {
                FRPPhotoModel *model = [[FRPPhotoModel alloc]init];
                //用返回数据初始化模型
                
                //加载预览图片
                
                return model;
            }] array]];
            [subject sendCompleted];
        }
        else{
            [subject sendError:connectionError];
        }
    }];
    return subject;
}

+ (NSURLRequest*)popularURLRequest
{
    return [appDelegate.apiHelper urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:100 page:0 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating except:PXPhotoModelCategoryNude];
}
@end
