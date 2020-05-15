//
//  TCSOPItem.h
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/9.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TCSOPItem <NSObject>

/// 设置某一列宽度的回调
@property (nonatomic, strong) CGFloat(^ columnWidthBlock)(NSInteger column);
/// 点击事件回调
@property (nonatomic, strong) void(^ touchedBlock)(id<TCSOPItem> obj);
/// 上级
@property (nonatomic, weak) id<TCSOPItem> parant;
/// 每一列的内容
- (NSArray<NSString*>*)textValues;
/// 下级内容
- (NSArray<id<TCSOPItem>>* _Nullable)items;
/// 层级
- (NSInteger)digitalDepth;
/// 获取视图
- (UIView*)getView;
/// 重载视图内容
- (void)reloadView;
/// 刷新下级内容
- (void)reloadChildren;
/// 切换展开/收起状态
- (void)switchExpand;

@end

NS_ASSUME_NONNULL_END
