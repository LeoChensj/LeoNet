//
//  ViewController.m
//  LeoNetDemo
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 MAC. All rights reserved.
//

/*
 1.Model文件夹里的三个类文件根据具体项目需要稍作修改。
 2.SearchModel文件夹里的三个类文件对应搜索接口，这三个类都继承自Model里的三个基类,
   每个具体的接口都需要建立三个类文件。
 */


#import "ViewController.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "SearchRequest.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btnSearch = [[UIButton alloc] init];
    btnSearch.backgroundColor = [UIColor blueColor];
    [btnSearch setTitle:@"搜  索" forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btnSearch];
    [btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(180);
        
    }];
    [btnSearch addTarget:self action:@selector(searchFunc) forControlEvents:UIControlEventTouchUpInside];
    
}










#pragma mark - btnFunc
- (void)searchFunc
{
    NSLog(@"搜索");
    
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    
    SearchRequestModel *model = [[SearchRequestModel alloc] init];
    model.q = @"a";
    model.start = @0;
    model.count = @10;
    
    SearchRequest *request = [[SearchRequest alloc] initWithRequestModel:model];
    [request startWithCompletionBlockWithSuccess:^(__kindof LeoBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        SearchRespModel *respModel = [request responseModel];
        
        NSLog(@"books=%@", respModel.books);
        
    } failure:^(__kindof LeoBaseRequest *request) {
        
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        NSLog(@"%@", [request getErrorMsg]);
        
    }];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
