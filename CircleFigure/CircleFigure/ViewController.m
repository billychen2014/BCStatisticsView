//
//  ViewController.m
//  CircleFigure
//
//  Created by Billy on 16/1/21.
//  Copyright © 2016年 zzjr. All rights reserved.
//

#import "ViewController.h"
#import "BCStatisticsView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *dic_data = @{[UIColor blueColor]:@"123.5",[UIColor orangeColor]:@"55.5",[UIColor cyanColor]:@"123.5",[UIColor brownColor]:@"123.5"};
    
    
    BCStatisticsView *view_test = [[BCStatisticsView alloc] initWithFrame:self.view.bounds detailsData:dic_data];
    
    [view_test setLineWidth:62.0];
    [view_test setBackgroundColor:[UIColor whiteColor]];
    
    [view_test setArray_rateOfEachColor:@[@"0.6",@"0.1",@"0.15",@"0.15"]];// 不指定会平均显示比率，若指定，count 和 上面的dic_data count 一定要一致
    [view_test setIsSpace:YES]; //可配置
    [view_test setStr_title:@"当前总资产 (元)"]; //可配置
    [view_test setStr_amountShown:@"88888.88"]; //可配置
    [view_test setIsAnimated:YES];
    [self.view addSubview:view_test];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
