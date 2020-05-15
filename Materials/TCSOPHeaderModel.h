//
//  TCSOPHeaderModel.h
//  TospurHouseBusiness
//
//  Created by shenwenxin on 2020/5/9.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCSOPItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCSOPHeaderModel : NSObject <TCSOPItem>

+ (instancetype)modelWithTitles:(NSArray<NSString*>*)titles;

- (void)loadItems:(NSArray<id<TCSOPItem>>*)items;
/// 是否展开
- (BOOL)isExpand;

@end

NS_ASSUME_NONNULL_END
