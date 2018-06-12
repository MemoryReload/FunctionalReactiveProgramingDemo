//
//  FRPPhotoImporter.h
//  FunctionalReactivePixels
//
//  Created by 何平 on 2018/6/8.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPPhotoImporter : NSObject
+(RACSignal*)importPhotos;
+(RACSignal*)fetchPotoDetailsWithModel:(FRPPhotoModel*)model;
@end
