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
    NSURLRequest *request = [self popularURLRequest];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [subject sendNext:[[[result[@"photos"] rac_sequence] map:^id _Nullable(id  _Nullable value) {
                FRPPhotoModel *model = [[FRPPhotoModel alloc]init];
                //用返回数据初始化模型
                [self configurePhotoModel:model withDictionary:value];
                //加载预览图片
                [self downloadThumbnailForPhotoModel:model];
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

+ (void)configurePhotoModel:(FRPPhotoModel*)model withDictionary:dictionary

{
    model.photoName = dictionary[@"name"];
    model.identifier = dictionary[@"id"];
    model.photographerName = dictionary[@"user"][@"username"];
    model.rating = dictionary[@"rating"];
    model.thumbnailURL = [self urlForImageSize:3 inArray:dictionary[@"images"]];
    
    if (dictionary[@"comments_count"]) {
        model.fullsizedURL = [self urlForImageSize:4 inArray:dictionary[@"images"]];
    }
}

+ (NSString*)urlForImageSize:(NSInteger)size inArray:(NSArray*)images
{
    return [[[[[images rac_sequence] filter:^BOOL(id  _Nullable value) {
        return [value[@"size"] integerValue] == size;
    }] map:^id _Nullable(id  _Nullable value) {
        return value[@"url"];
    }] array] firstObject];
}

+ (void)downloadThumbnailForPhotoModel:(FRPPhotoModel*)model
{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.thumbnailURL]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        model.thumbnailData = data;
    }];
}
@end
