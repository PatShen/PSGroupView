//
//  TCExpandTableView.h
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCExpandTableViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCExpandTableView : UIView

/// 获取第一行标题的回调，会根据标题数量确定列数
@property (nonatomic, strong) id<TCExpandTableViewHeader>(^ headerBlock)(void);
/// 获取最高层级 item 的回调
@property (nonatomic, strong) NSArray<id<TCExpandTableViewLevel>>*(^ topItemsBlock)(void);
/// 设置某一列的宽度的回调
@property (nonatomic, strong) CGFloat(^ columnWidthBlock)(NSInteger column);
/// 点击最底层 item 的回调
@property (nonatomic, strong) void(^ selectBottomItemBlock)(id<TCExpandTableViewItem> item);

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
