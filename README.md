# srollerView-WaterFall
一个用scroollerView编写的瀑布流，在插入的时候根据每一列的最大的Y值判断，那个Y值最小就就将该cell插入到该列

#代理方法 
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

#数据源方法
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
 * 一共有多少列 默认是3列
 */
- (NSInteger)numberOfColumnsInWaterflowView:(LQWaterFallView*)waterFallView;
@end
