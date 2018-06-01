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
@property (strong, nonatomic) IBOutlet UITextField *accountField;
@property (strong, nonatomic) IBOutlet UIButton *createBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[self.accountField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"Current account text is: %@",x);
    }];
    
    RACSignal* validSignal = [[self.accountField rac_textSignal] map:^id _Nullable(NSString * _Nullable value) {
        return @([(NSString*)value containsString:@"@"]);
    }];
//    RAC(self.createBtn, enabled) = validSignal;
    self.createBtn.rac_command = [[RACCommand alloc]initWithEnabled:validSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"Create button clicked with input: %@",input);
        return [RACSignal empty];
    }];
    
    RAC(self.accountField, textColor) = [validSignal map:^id _Nullable(id  _Nullable value) {
        if ([(NSNumber*)value boolValue]) {
            return [UIColor greenColor];
        }
        else{
            return [UIColor redColor];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
