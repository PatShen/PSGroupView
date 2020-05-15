//
//  TCExpandTableViewProtocol.h
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TCExpandTableViewProtocol <NSObject>

@end

@protocol TCExpendTableViewHeader <NSObject>
/// 标题
- (NSArray<NSString*>*)titles;

@end

typedef NS_ENUM(NSUInteger, TCSOPItemType) {
    /// 部门
    TCSOPItemTypeDepartment,
    /// 成员
    TCSOPItemTypeMember,
};

@protocol TCExpendTableViewItem <NSObject>

/// 部门层级
- (NSInteger)digitalLevel;
/// 类型
- (TCSOPItemType)itemType;
/// 内容
- (NSArray<NSString*>*)contents;

@end

NS_ASSUME_NONNULL_END
