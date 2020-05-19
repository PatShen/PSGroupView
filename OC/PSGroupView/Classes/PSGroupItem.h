//
//  PSGroupItem.h
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/19.
//  Copyright © 2020 swx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PSGroupItem <NSObject>

/// 设置某一列宽度的回调
@property (nonatomic, strong) CGFloat(^ columnWidthBlock)(NSInteger column);
/// 点击事件回调
@property (nonatomic, strong) void(^ touchedBlock)(id<PSGroupItem>_Nullable obj);
/// 上级
@property (nonatomic, weak) id<PSGroupItem> parant;

/// 每一列的内容
- (NSArray<NSString*>*)textValues;
/// 下级内容
- (NSArray<id<PSGroupItem>>* _Nullable)items;
/// 层级
- (NSInteger)digitalDepth;
/// 获取视图
- (UIView*)getView;
/// 重载视图内容
- (void)reloadView;
/// 刷新下级内容
- (void)reloadChildren;
/// 切换展开/收起状态
- (void)switchExpand:(BOOL)isExpand;
/// 是否是最底层的 item（人员）
- (BOOL)isBottomLevelItem;

@end

NS_ASSUME_NONNULL_END
