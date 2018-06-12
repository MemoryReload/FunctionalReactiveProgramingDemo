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
@end

@implementation FRPGalleryCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

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
    
    // Do any additional setup after loading the view.
    @weakify(self);
    [RACObserve(self, photos) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [self loadPopularPhotos];
}

- (void)loadPopularPhotos
{
    [SVProgressHUD show];
    [[FRPPhotoImporter importPhotos] subscribeNext:^(id  _Nullable x) {
        self.photos = x;
        [SVProgressHUD dismiss];
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:error.localizedDescription]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <FRPFullSizedPhotoViewControllerDelegate>

-(void)userDidScroll:(FRPFullSizedPhotoViewController *)viewController toPotoIndex:(NSInteger)index
{
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
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
    [cell setPhotoModel:[self.photos objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@">>>>>>>>>>highlight");
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"<<<<<<<<<unhighlight");
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRPFullSizedPhotoViewController* fullSizedVC = [[FRPFullSizedPhotoViewController alloc]initWithPhotos:self.photos currentPhotoIndex:indexPath.row];
    fullSizedVC.delegate = self;
    [self.navigationController pushViewController:fullSizedVC animated:YES];
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
