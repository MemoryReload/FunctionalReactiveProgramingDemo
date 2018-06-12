//
//  FRPPhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by Heping on 2018/6/11.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import "FRPPhotoViewController.h"
#import "FRPPhotoModel.h"
#import "FRPPhotoImporter.h"

@interface FRPPhotoViewController ()
@property (nonatomic,assign,readwrite) NSUInteger photoIndex;
@property (nonatomic,strong,readwrite) FRPPhotoModel* model;
@property (nonatomic,weak) UIImageView* imageView;
@end

@implementation FRPPhotoViewController

-(instancetype)initWithPhotoModel:(FRPPhotoModel*)model photoIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _photoIndex = index;
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    UIImageView* temp = [[UIImageView alloc] initWithFrame:self.view.bounds];
    temp.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    temp.contentMode = UIViewContentModeScaleAspectFit;
    RAC(temp,image) = [RACObserve(self.model,fullsizedData) map:^id _Nullable(id  _Nullable value) {
        return [UIImage imageWithData:value];
    }];
    [self.view addSubview:temp];
    self.imageView = temp;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.model.fullsizedData) {
        [SVProgressHUD show];
        [[FRPPhotoImporter fetchPotoDetailsWithModel:self.model] subscribeNext:^(id  _Nullable x) {
            [SVProgressHUD dismiss];
        } error:^(NSError * _Nullable error) {
            [SVProgressHUD showWithStatus:error.localizedDescription];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
