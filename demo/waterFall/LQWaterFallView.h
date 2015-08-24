//
//  LQWaterFallView.h
//  瀑布流
//
//  Created by leyi on 15/8/20.
//  Copyright (c) 2015年 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LQWaterFallView,LQWaterFallViewCell;


typedef enum {
    LQWaterFallViewMarginTypeTop,
    LQWaterFallViewMarginTypeBottom,
    LQWaterFallViewMarginTypeLeft,
    LQWaterFallViewMarginTypeRight,
    LQWaterFallViewMarginTypeColumn,
    LQWaterFallViewMarginTypeRow
} LQWaterFallViewMarginType;


/*
 *  waterFallView 的数据源
 */
@protocol LQWaterFallViewDataSource <NSObject>
/*
 * 必须实现的方法
 */
@required

/**
 *  一共有多少个数据
 */
- (NSUInteger)numberOfCellsInWaterFlowView:(LQWaterFallView *)waterflowView;
/*
 * 每一个index如何现显示cell
 */
- (LQWaterFallViewCell*)waterFallView:(LQWaterFallView *)waterFallView cellForIndex:(NSUInteger)index;
/*
 * 可以选择实现的方法
 */
@optional
/*
 * 一共有多少列
 */
- (NSInteger)numberOfColumnsInWaterflowView:(LQWaterFallView*)waterFallView;
@end



/*
 * waterFallView的代理方法
 */
@protocol LQWaterFallViewDelegate <UIScrollViewDelegate>
/*
 * 可以选择实现的方法
 */
@optional
/*
 * 第index的cell 对应的高度
 */
- (CGFloat)waterFallView:(LQWaterFallView*)waterFallView heightAtIndex:(NSInteger)index;
/*
 * 选中第index 的cell
 */
- (void)waterFallView:(LQWaterFallView*)waterFallView didSelectAtIndex:(NSInteger)index;

/*
 *  根据不同类型返回相应得间距
 */
- (CGFloat)waterFallView:(LQWaterFallView *)waterFallView marginWithType:(LQWaterFallViewMarginType)type;

@end


@interface LQWaterFallView : UIScrollView

@property(nonatomic,weak) id <LQWaterFallViewDataSource> dataSource;
@property(nonatomic,weak) id <LQWaterFallViewDelegate> delegate;

/*
 * 公共方法刷新数据 （只要调用这个方法，会重新向数据源和代理发送请求，请求数据）
 */
- (void)relodata;
/**
 *  根据标识去缓存池查找可循环利用的cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
