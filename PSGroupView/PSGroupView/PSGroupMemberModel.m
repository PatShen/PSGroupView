//
//  PSGroupMemberModel.m
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/19.
//  Copyright © 2020 swx. All rights reserved.
//

#import "PSGroupMemberModel.h"
#import "PSGroupView.h"

@interface PSGroupMemberModel ()

/// 深度
@property (nonatomic, assign) NSInteger depth;
/// 视图
@property (nonatomic, strong) PSGroupView* viewItems;

/// 名字
@property (nonatomic, copy) NSString* name;

@property (nonatomic, strong) NSMutableArray<NSString*>* values;

@end

@implementation PSGroupMemberModel

@synthesize columnWidthBlock;
@synthesize parant;
@synthesize touchedBlock;

- (NSInteger)digitalDepth {
    return self.depth;
}

- (nonnull UIView *)getView {
    return self.viewItems;
}

- (BOOL)isBottomLevelItem {
    return YES;
}

- (NSArray<id<PSGroupItem>> * _Nullable)items {
    return @[];
}

- (void)reloadChildren {
    
}

- (void)reloadView {
    [_viewItems reloadData];
}

- (void)switchExpand:(BOOL)isExpand {
    
}

- (nonnull NSArray<NSString *> *)textValues {
    NSMutableArray* array = @[].mutableCopy;
    [array addObject:_name];
    [array addObjectsFromArray:_values];
    return array;
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
        PSGroupView* view = [PSGroupView viewForPerson];
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
            if (weakSelf.touchedBlock) {
                weakSelf.touchedBlock(weakSelf);
            }
        }];
        _viewItems = view;
    }
    return _viewItems;
}

@end
