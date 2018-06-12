//
//  FRPFullSizedPhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by Heping on 2018/6/11.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import "FRPFullSizedPhotoViewController.h"
#import "FRPPhotoViewController.h"
#import "FRPPhotoModel.h"

@interface FRPFullSizedPhotoViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic,strong,readwrite) NSArray* photos;
@property (nonatomic,weak) UIPageViewController* pageViewController;
@end

@implementation FRPFullSizedPhotoViewController

-(instancetype)initWithPhotos:(NSArray*)photos currentPhotoIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _photos = photos;
        
        self.title = [(FRPPhotoModel*)[_photos objectAtIndex:index] photoName];
        
        UIPageViewController* temp = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(0)}];
        temp.dataSource=self;
        temp.delegate=self;
        [self addChildViewController:temp];
        
        _pageViewController = temp;
        [_pageViewController setViewControllers:@[[self photoViewControllerForIndex:index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.pageViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageViewController.view];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController*)photoViewControllerForIndex:(NSInteger)index
{
    if (index>=0 || index < self.photos.count) {
        FRPPhotoModel* model = [self.photos objectAtIndex:index];
        FRPPhotoViewController* photoVC = [[FRPPhotoViewController alloc]initWithPhotoModel:model photoIndex:index];
        return photoVC;
    }
    return nil;
}

#pragma mark - pageViewControllerDelegate & DataSource
- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    return [self photoViewControllerForIndex:[(FRPPhotoViewController*)viewController photoIndex]+1];
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    return [self photoViewControllerForIndex:[(FRPPhotoViewController*)viewController photoIndex]-1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.title = [[(FRPPhotoViewController*)[self.pageViewController.viewControllers firstObject] model] photoName];
    if (self.delegate && [self.delegate respondsToSelector:@selector(userDidScroll:toPotoIndex:)]) {
        [self.delegate userDidScroll:self toPotoIndex:[(FRPPhotoViewController*)[self.pageViewController.viewControllers firstObject] photoIndex]];
    }
}
@end
