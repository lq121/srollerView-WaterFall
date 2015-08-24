//
//  LQWaterFallView.m
//  瀑布流
//
//  Created by leyi on 15/8/20.
//  Copyright (c) 2015年 LQ. All rights reserved.
//

#import "LQWaterFallView.h"
#import "LQWaterFallViewCell.h"

/* 默认的列数*/
#define LQWaterFallViewDefaultNumberOfColumns 3
/* 默认的间距*/
#define LQWaterFallViewDefaultMargin 10
/* 默认的cell的高度*/
#define LQWaterFallViewCellDefaultHeight 70

@interface LQWaterFallView()

/**
 *  正在展示的cell
 */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;
/*
 * 所有的cell的frame数据
 */
@property(nonatomic,strong)NSMutableArray *cellFrames;
/**
 *  缓存池（用Set，存放离开屏幕的cell）
 */
@property (nonatomic, strong) NSMutableSet *reusableCells;
@end

@implementation LQWaterFallView

- (NSMutableSet *)reusableCells
{
    if (_reusableCells == nil)
    {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

- (NSMutableDictionary *)displayingCells
{
    if (_displayingCells == nil)
    {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}
- (NSMutableArray *)cellFrames
{
    if (_cellFrames == nil)
    {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}


/**
 *  当UIScrollView滚动的时候也会调用这个方法
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger numberOfCells = self.cellFrames.count;
    for (int i = 0 ; i < numberOfCells; i++)
    {
        // 取出i 位置对应得cell的frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        // 从字典中优先取出
        LQWaterFallViewCell *cell = self.displayingCells[@(i)];
        // 判断cell 是否在屏幕上
        if([self isInScreenWithFrame:cellFrame])
        {
            if (cell == nil)
            {
                cell = [self.dataSource waterFallView:self cellForIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                self.displayingCells[@(i)] = cell;
            }
        }
        else // 不在屏幕上
        {
            if (cell)
            {
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                // 存放到缓存池
                [self.reusableCells addObject:cell];
            }
           
        }
        
    }
}


/*
 * 循环引用
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block LQWaterFallViewCell *cell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(LQWaterFallViewCell* waterFallViewCell, BOOL *stop) {
        cell = waterFallViewCell;
        *stop = YES;
    }];
    if (cell) // 从缓存池中移除
    {
        [self.reusableCells removeObject:cell];
    }
    return cell;
}


/*
 * 刷新数据
 */
- (void)relodata
{
    // cell的总的数据
    NSInteger numberOfCells = [self.dataSource numberOfCellsInWaterFlowView:self];
    // 列数
    NSInteger numberOfColumns = [self numberOfColumns];
    // 各个位置的间距
    CGFloat toopMargin = [self marginForType:LQWaterFallViewMarginTypeTop];
    CGFloat bottomMargin = [self marginForType:LQWaterFallViewMarginTypeBottom];
    CGFloat leftMargin = [self marginForType:LQWaterFallViewMarginTypeLeft];
    CGFloat rightMargin = [self marginForType:LQWaterFallViewMarginTypeRight];
    CGFloat columnMargin = [self marginForType:LQWaterFallViewMarginTypeColumn];
    CGFloat rowMargin = [self marginForType:LQWaterFallViewMarginTypeRow];
    
    // 定义一个c语言的数组存放每一列最大的Y值
    CGFloat MaxYforColumn[numberOfColumns];
    //
    for (int i  = 0; i  <  numberOfColumns; i++)
    {
        MaxYforColumn[i] = 0.0;
    }
    
    
    // 设置每一个cell的frame
    CGFloat  cellW= (self.width - leftMargin - rightMargin - columnMargin * (numberOfColumns - 1))/ numberOfColumns;
    for(NSUInteger i = 0 ; i < numberOfCells; i++)
    {
        CGFloat cellH = [self cellheightAtIndex:i];
        // cell处在第几列(最短的一列)
        NSUInteger cellColumn = 0;
        // cell所处那列的最大Y值(最短那一列的最大Y值)
        CGFloat maxYOfCellColumn = MaxYforColumn[cellColumn];
        for (int j = 1 ; j < numberOfColumns; j++)
        {
            if (MaxYforColumn[j] < maxYOfCellColumn)
            {
                maxYOfCellColumn = MaxYforColumn[j];
                cellColumn = j;
            }
        }
        CGFloat cellX = leftMargin + cellColumn *(cellW + columnMargin);
        CGFloat cellY;
        // 如果是首页
        if (cellY == 0)
        {
            cellY = toopMargin;
        }
        else
        {
            cellY = maxYOfCellColumn + rowMargin;
        }
        CGRect frame = CGRectMake(cellX, cellY, cellW, cellH);
        
        [self.cellFrames addObject:[NSValue valueWithCGRect:frame]];
        // 跟新最短列的最大y值
        MaxYforColumn[cellColumn] = CGRectGetMaxY(frame);
    }
    // 设置scrollView 的contentSize
    CGFloat contentH = MaxYforColumn[0];
    for (int k = 1; k< numberOfColumns; k++)
    {
        if (MaxYforColumn[k] > contentH)
        {
            contentH = MaxYforColumn[k];
        }
    }
    contentH += bottomMargin;
    self.contentSize = CGSizeMake(0, contentH);
    
}


#pragma mark - 私有方法
- (CGFloat)cellheightAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterFallView:heightAtIndex:)])
    {
        return [self.delegate waterFallView:self heightAtIndex:index];
    }
    else
    {
        return LQWaterFallViewCellDefaultHeight;
    }
}

/*
 * 求列数
 * 返回多少列
 */
- (NSInteger)numberOfColumns
{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflowView:)] )
    {
        return [self.dataSource numberOfColumnsInWaterflowView:self];
    }
    else
    {
        return LQWaterFallViewDefaultNumberOfColumns;
    }
}

/*
 * 各个方向的间隙
 * 返回间隙
 */
- (CGFloat)marginForType:(LQWaterFallViewMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterFallView:marginWithType:)])
    {
        return [self.delegate waterFallView:self marginWithType:type];
    }
    else
    {
        return LQWaterFallViewDefaultMargin;
    }
}

/*
 * 判断frame是否在屏幕上
 */
- (BOOL)isInScreenWithFrame:(CGRect)frame
{
    return ((CGRectGetMaxY(frame) > self.contentOffset.y) && (CGRectGetMinY(frame)< self.contentOffset.y + self.height));
}

#pragma mark - 事件处理
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(waterFallView:didSelectAtIndex:)]) return;
    
    // 获得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber *selectIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id key, LQWaterFallViewCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
    }];
    
    if (selectIndex) {
        [self.delegate waterFallView:self didSelectAtIndex:selectIndex.unsignedIntegerValue];
    }
}

/**
 * 进入页面自动刷新
 */
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self relodata];
}

@end
