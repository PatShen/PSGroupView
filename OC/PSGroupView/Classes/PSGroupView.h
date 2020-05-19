//
//  PSGroupView.h
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/19.
//  Copyright © 2020 swx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSGroupItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PSGroupView : UIView

/// 设置某一列的宽度的回调
@property (nonatomic, strong) CGFloat(^ columnWidthBlock)(NSInteger column);
/// 加载数据的回调
@property (nonatomic, strong) id<PSGroupItem>(^ loadDataBlock)(void);
/// 点击事件回调
@property (nonatomic, strong) void(^ touchedBlock)(void);
/// 是否为展开状态
@property (nonatomic, assign, readonly) BOOL isExpand;
/// 刷新内容
- (void)reloadData;
/// 刷新下级内容
- (void)reloadChildren;
/// 切换展开/收起状态
- (void)switchExpand:(BOOL)isExpand;

@end


@interface PSGroupView (Creation)

+ (instancetype)viewForHeader;

+ (instancetype)viewForDepartment;

+ (instancetype)viewForPerson;

@end

NS_ASSUME_NONNULL_END
