//
//  ViewController.m
//  RACPlayground
//
//  Created by Heping on 2018/5/30.
//  Copyright © 2018年 BONC. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray* array = @[@(1), @(2), @(3), @(4), @(5), @(6)];
    RACSequence* sequence = [array rac_sequence];
    [sequence map:^id _Nullable(id  _Nullable value) {
        return @(pow([(NSNumber*)value integerValue], 2));
    }];
    NSLog(@"pow array: %@",[sequence array]);
    
    NSLog(@"even array: %@",[[[array rac_sequence] filter:^BOOL(id  _Nullable value) {
        return [(NSNumber*)value integerValue] % 2 == 0;
    }] array]);
    
    NSLog(@"fold string : %@",[[[array rac_sequence] map:^id _Nullable(id  _Nullable value) {
        return [(NSNumber*)value stringValue];
    }] foldLeftWithStart:@"" reduce:^id _Nullable(id  _Nullable accumulator, id  _Nullable value) {
        return [(NSString*)accumulator stringByAppendingString:(NSString*)value];
    }]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
