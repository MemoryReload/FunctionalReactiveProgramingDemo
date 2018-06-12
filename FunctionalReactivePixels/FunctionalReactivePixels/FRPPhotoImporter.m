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
                //用返回数据初始化模型
                FRPPhotoModel *model = [[FRPPhotoModel alloc]init];
                [self configurePhotoModel:model withDictionary:value];
                //加载预览图片
                [self downloadThumbnailDataForPhotoModel:model];
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

+(RACSignal*)fetchPotoDetailsWithModel:(FRPPhotoModel*)model
{
    RACSubject* subject = [RACReplaySubject subject];
    NSURLRequest* request = [self photoURLRequestWithModel:model];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //重设数据模型
            [self configurePhotoModel:model withDictionary:result[@"photo"]];
            //加载完整图片
            [self downloadFullSizedDataForPhotoModel:model];
            [subject sendNext:model];
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

+(NSURLRequest*)photoURLRequestWithModel:(FRPPhotoModel*)model
{
    return [appDelegate.apiHelper urlRequestForPhotoID:[model.identifier integerValue]];
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

+ (void)downloadThumbnailDataForPhotoModel:(FRPPhotoModel*)model
{
    NSURL* url = [NSURL URLWithString:model.thumbnailURL];
    [self downloadWithURL:url completion:^(NSData * data) {
        model.thumbnailData = data;
    }];
}

+ (void)downloadFullSizedDataForPhotoModel:(FRPPhotoModel*)model
{
    NSURL* url = [NSURL URLWithString:model.fullsizedURL];
    [self downloadWithURL:url completion:^(NSData *data) {
        model.fullsizedData = data;
    }];
}

+(void)downloadWithURL:(NSURL*)url completion:(void(^)(NSData* data))completion
{
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (completion) {
            completion(data);
        }
    }];
}
@end
