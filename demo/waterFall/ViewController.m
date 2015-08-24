//
//  ViewController.m
//  瀑布流
//
//  Created by leyi on 15/8/20.
//  Copyright (c) 2015年 LQ. All rights reserved.
//

#import "ViewController.h"
#import "LQWaterFallView.h"
#import "LQWaterFallViewCell.h"


@interface ViewController ()<LQWaterFallViewDataSource,LQWaterFallViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LQWaterFallView *waterFallView = [[LQWaterFallView alloc]init];
    waterFallView.frame = self.view.bounds;
    waterFallView.dataSource =self;
    waterFallView.delegate  = self;
    [self.view addSubview:waterFallView];
}


#pragma mark - LQWaterFallView的数据源方法
- (LQWaterFallViewCell *)waterFallView:(LQWaterFallView *)waterFallView cellForIndex:(NSUInteger)index
{
    NSString *identifer = @"cell";
    LQWaterFallViewCell *cell = [waterFallView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil)
    {
        cell = [[LQWaterFallViewCell alloc]init];
        cell.identifier  = identifer;
         cell.backgroundColor = LQRandomColor;
         UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        label.tag = 10;
          [cell addSubview:label];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%lu", (unsigned long)index];

    NSLog(@"%lu %p", (unsigned long)index, cell);
    return cell;
}

- (NSUInteger)numberOfCellsInWaterFlowView:(LQWaterFallView *)waterflowView
{
    return  50;
}

- (NSInteger)numberOfColumnsInWaterflowView:(LQWaterFallView *)waterFallView
{
    return 4;
}


#pragma mark - waterFallView的代理方法
- (CGFloat)waterFallView:(LQWaterFallView *)waterFallView marginWithType:(LQWaterFallViewMarginType)type
{
    switch (type) {
        case LQWaterFallViewMarginTypeTop:
        case LQWaterFallViewMarginTypeBottom:
        case  LQWaterFallViewMarginTypeLeft:
        case LQWaterFallViewMarginTypeRight:
            return 10;
            break;
        default:
            return 5;
            break;
    }
}


- (void)waterFallView:(LQWaterFallView *)waterFallView didSelectAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld个cell",(long)index);
}

- (CGFloat)waterFallView:(LQWaterFallView *)waterFallView heightAtIndex:(NSInteger)index
{
    switch (index %3)
    {
        case 0:
            return 40;
            break;
        case 1:
            return 70;
        case 2:
            return 110;
        default:
            return 80;
            break;
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
