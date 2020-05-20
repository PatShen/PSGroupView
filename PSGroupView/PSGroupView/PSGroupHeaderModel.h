//
//  PSGroupHeaderModel.h
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/19.
//  Copyright © 2020 swx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSGroupItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PSGroupHeaderModel : NSObject <PSGroupItem>

+ (instancetype)modelWithTitles:(NSArray<NSString*>*)titles;

- (void)loadItems:(NSArray<id<PSGroupItem>>*)items;

/// 是否展开
- (BOOL)isExpand;

@end

NS_ASSUME_NONNULL_END
