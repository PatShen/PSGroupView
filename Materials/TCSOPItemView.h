//
//  TCSOPItemView.h
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCSOPItem.h"

NS_ASSUME_NONNULL_BEGIN

@class TCSOPItemModel;

@interface TCSOPItemView : UIView

/// 设置某一列的宽度的回调
@property (nonatomic, strong) CGFloat(^ columnWidthBlock)(NSInteger column);
/// 加载数据的回调
@property (nonatomic, strong) id<TCSOPItem>(^ loadDataBlock)(void);
/// 点击事件回调
@property (nonatomic, strong) void(^ touchedBlock)(void);

@property (nonatomic, assign, readonly) BOOL isExpand;
/// 刷新内容
- (void)reloadData;
/// 刷新下级内容
- (void)reloadChildren;
/// 切换展开/收起状态
- (void)switchExpand;
- (void)switchExpand:(BOOL)isExpand;
///
- (void)manualConstraintTableView;

@end


@interface TCSOPItemView (Creation)

+ (instancetype)viewForHeader;

+ (instancetype)viewForDepartment;

+ (instancetype)viewForPerson;

@end

NS_ASSUME_NONNULL_END
