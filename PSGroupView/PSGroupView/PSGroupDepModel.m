//
//  PSGroupDepModel.m
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/19.
//  Copyright © 2020 swx. All rights reserved.
//

#import "PSGroupDepModel.h"
#import "PSGroupView.h"
#import "PSGroupMemberModel.h"

@interface PSGroupDepModel ()

/// 深度
@property (nonatomic, assign) NSInteger depth;
/// 视图
@property (nonatomic, strong) PSGroupView* viewItems;

/// 名字
@property (nonatomic, copy) NSString* name;

@property (nonatomic, strong) NSMutableArray<NSString*>* values;
/// 下级部门
@property (nonatomic, strong) NSMutableArray<PSGroupDepModel*>* subItems;
/// 成员
@property (nonatomic, strong) NSMutableArray<id<PSGroupItem>>* members;

@end

@implementation PSGroupDepModel

@synthesize columnWidthBlock;
@synthesize parant;
@synthesize touchedBlock;

- (NSInteger)digitalDepth {
    return self.depth;
}

- (UIView *)getView {
    return self.viewItems;
}

- (BOOL)isBottomLevelItem {
    return NO;
}

- (NSArray<id<PSGroupItem>> * _Nullable)items {
    NSMutableArray* array = @[].mutableCopy;
    [array addObjectsFromArray:self.subItems];
    [array addObjectsFromArray:self.members];
    return array;
}

- (void)reloadChildren {
    [_viewItems reloadChildren];
}

- (void)reloadView {
    [_viewItems reloadData];
}

- (void)switchExpand:(BOOL)isExpand {
    [_viewItems switchExpand:isExpand];
}

- (nonnull NSArray<NSString *> *)textValues {
    NSMutableArray* array = @[].mutableCopy;
    [array addObject:_name];
    [array addObjectsFromArray:_values];
    return array;
}

// MARK: YYModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"subItems":[PSGroupDepModel class],
             @"members":[PSGroupMemberModel class]
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([self.subItems isKindOfClass:[NSArray class]] && self.subItems.count > 0) {
        for (id<PSGroupItem> sub in self.subItems) {
            sub.parant = self;
            __weak typeof(self) weakSelf = self;
            [sub setColumnWidthBlock:^CGFloat(NSInteger column) {
                CGFloat width = 0.0;
                if (weakSelf.columnWidthBlock) {
                    width = weakSelf.columnWidthBlock(column);
                }
                return width;
            }];
            [sub setTouchedBlock:^(id<PSGroupItem>  _Nonnull obj) {
                [weakSelf.parant reloadChildren];
                if (weakSelf.touchedBlock) {
                    weakSelf.touchedBlock(obj);
                }
            }];
        }
    }
    if ([self.members isKindOfClass:[NSArray class]] && self.members.count > 0) {
        for (id<PSGroupItem> sub in self.members) {
            sub.parant = self;
            __weak typeof(self) weakSelf = self;
            [sub setColumnWidthBlock:^CGFloat(NSInteger column) {
                CGFloat width = 0.0;
                if (weakSelf.columnWidthBlock) {
                    width = weakSelf.columnWidthBlock(column);
                }
                return width;
            }];
            [sub setTouchedBlock:^(id<PSGroupItem>  _Nonnull obj) {
                [weakSelf.parant reloadChildren];
                if (weakSelf.touchedBlock) {
                    weakSelf.touchedBlock(obj);
                }
            }];
        }
    }
    return YES;
}

// MARK: Getter
- (NSInteger)depth {
    NSInteger value = 0;
    id<PSGroupItem> model = self.parant;
    while (model) {
        model = model.parant;
        value++;
    }
    return value;
}

- (PSGroupView *)viewItems {
    if (_viewItems == nil) {
        PSGroupView* view = [PSGroupView viewForDepartment];
        __weak typeof(self) weakSelf = self;
        [view setLoadDataBlock:^id<PSGroupItem> _Nonnull{
            return weakSelf;
        }];
        [view setColumnWidthBlock:^CGFloat(NSInteger column) {
            CGFloat width = 0.0;
            if (weakSelf.columnWidthBlock) {
                width = weakSelf.columnWidthBlock(column);
            }
            return width;
        }];
        [view setTouchedBlock:^{
            [weakSelf switchExpand:!weakSelf.viewItems.isExpand];
            [weakSelf.parant reloadChildren];
            if (weakSelf.touchedBlock) {
                weakSelf.touchedBlock(nil);
            }
        }];
        _viewItems = view;
    }
    return _viewItems;
}

@end
