//
//  TCSOPItemModel.h
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TCSOPItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCSOPItemModel : NSObject <TCSOPItem>

/// 设置某一列的宽度的回调
@property (nonatomic, strong) CGFloat(^ columnWidthBlock)(NSInteger column);
/// 点击事件回调
@property (nonatomic, strong) void(^ touchedBlock)(id);
/// 上级
@property (nonatomic, weak) TCSOPItemModel* parant;

- (NSArray<NSString*>*)textValues;

- (NSArray<TCSOPItemModel*>*)items;

- (NSInteger)digitalDepth;

- (UIView*)getView;

- (void)reloadView;

- (void)reloadChildren;

- (void)switchExpand:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
