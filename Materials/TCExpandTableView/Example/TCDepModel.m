//
//  TCDepModel.m
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import "TCDepModel.h"

@interface TCDepModel ()

@property (nonatomic, copy) NSString* level;

@property (nonatomic, strong) NSArray* subLevels;

@property (nonatomic, copy) NSString* name;

@property (nonatomic, copy) NSString* value1;
@property (nonatomic, copy) NSString* value2;
@property (nonatomic, copy) NSString* value3;

@end

@implementation TCDepModel

// MARK: TCExpandTableViewLevel
- (NSInteger)digitalLevel {
    return [_level integerValue];
}

- (NSArray *)subLevel {
    return _subLevels;
}

- (BOOL)isExpanded {
    return YES;
}

- (NSArray<NSString *> *)contents {
    return @[_name,_value1,_value2,_value3];
}

@end
