//
//  FRPGalleryCollectionViewController.m
//  FunctionalReactivePixels
//
//  Created by Heping on 2018/6/7.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import "FRPGalleryCollectionViewController.h"
#import "FRPGalleryFlowLayout.h"
#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"
#import "FRPGalleryCollectionViewCell.h"
#import "FRPFullSizedPhotoViewController.h"

@interface FRPGalleryCollectionViewController () <FRPFullSizedPhotoViewControllerDelegate>
@property (nonatomic,strong) NSArray<FRPPhotoModel*>* photos;
@property (nonatomic,strong) RACDelegateProxy* collectionViewDelegate;
@property (nonatomic,strong) RACDelegateProxy* fullSizePhotoViewControllerDelegate;
@end

@implementation FRPGalleryCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

-(RACDelegateProxy *)collectionViewDelegate
{
    if (!_collectionViewDelegate) {
        _collectionViewDelegate = [[RACDelegateProxy alloc]initWithProtocol:@protocol(UICollectionViewDelegate)];
        @weakify(self);
        [[_collectionViewDelegate rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            NSIndexPath* indexPath = [x second];
            FRPFullSizedPhotoViewController* fullSizedVC = [[FRPFullSizedPhotoViewController alloc]initWithPhotos:self.photos currentPhotoIndex:indexPath.row];
            fullSizedVC.delegate = (id<FRPFullSizedPhotoViewControllerDelegate>)self.fullSizePhotoViewControllerDelegate;
            [self.navigationController pushViewController:fullSizedVC animated:YES];
        }];
    }
    return _collectionViewDelegate;
}

-(RACDelegateProxy *)fullSizePhotoViewControllerDelegate
{
    if (!_fullSizePhotoViewControllerDelegate) {
        _fullSizePhotoViewControllerDelegate = [[RACDelegateProxy alloc]initWithProtocol:@protocol(FRPFullSizedPhotoViewControllerDelegate)];
        @weakify(self);
        [[_fullSizePhotoViewControllerDelegate signalForSelector:@selector(userDidScroll:toPotoIndex:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            NSInteger index = [[x second] integerValue];
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        }];
    }
    return _fullSizePhotoViewControllerDelegate;
}

-(instancetype)init
{
    FRPGalleryFlowLayout* layout = [[FRPGalleryFlowLayout alloc]init];
    self = [self initWithCollectionViewLayout:layout];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"Popular";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    [self.collectionView registerClass:[FRPGalleryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Set collection view delegate
    self.collectionView.delegate = (id<UICollectionViewDelegate>)self.collectionViewDelegate;
    
    // Do any additional setup after loading the view.
    
//        RACSignal* signal = [FRPPhotoImporter importPhotos];
//        RACSignal* loaded = [signal catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//            return [RACSignal empty];
//        }];
//        RAC(self,self.photos) = loaded;
//        @weakify(self);
//        [loaded subscribeCompleted:^{
//            @strongify(self);
//            [SVProgressHUD dismiss];
//            [self.collectionView reloadData];
//        }];
    
    [SVProgressHUD show];
    @weakify(self);
    RAC(self,self.photos) = [[[[FRPPhotoImporter importPhotos] doCompleted:^{
        @strongify(self);
        [SVProgressHUD dismiss];
        [self.collectionView reloadData];
    }] doError:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }] catchTo:[RACSignal empty]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.model = [self.photos objectAtIndex:indexPath.row];
    return cell;
}
@end
