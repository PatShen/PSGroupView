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

@protocol TCExpandTableViewHeader <NSObject>
/// 标题
- (NSArray<NSString*>*)titles;

@end

@protocol TCExpandTableViewItem <NSObject>
/// 内容
- (NSArray<NSString*>*)contents;

@end

@protocol TCExpandTableViewLevel <TCExpandTableViewItem>

/// 层级
- (NSInteger)digitalLevel;
/// 下级数组
- (NSArray*)subLevel;
/// 是否展开
- (BOOL)isExpanded;

@end



NS_ASSUME_NONNULL_END
