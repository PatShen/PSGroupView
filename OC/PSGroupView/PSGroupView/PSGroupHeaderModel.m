//
//  PSGroupHeaderModel.m
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/19.
//  Copyright © 2020 swx. All rights reserved.
//

#import "PSGroupHeaderModel.h"
#import "PSGroupView.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import "PSGroupDepModel.h"

@interface PSGroupHeaderModel () <YYModel>

@property (nonatomic, copy) NSString* name;

@property (nonatomic, strong) NSMutableArray<NSString*>* values;

@property (nonatomic, strong) NSMutableArray<PSGroupDepModel*>* subItems;

@property (nonatomic, assign) NSInteger depth;

@property (nonatomic, strong) UIView* viewContent;

@property (nonatomic, strong) PSGroupView* viewItems;

@end

@implementation PSGroupHeaderModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.subItems = @[].mutableCopy;
    }
    return self;
}

+ (instancetype)modelWithTitles:(NSArray<NSString *> *)titles {
    PSGroupHeaderModel* model = [[PSGroupHeaderModel alloc] init];
    model.values = [NSMutableArray arrayWithArray:titles];
    return model;
}

- (void)loadItems:(NSArray<id<PSGroupItem>> *)items {
    self.subItems = [NSMutableArray arrayWithArray:items];
    __weak typeof(self) weakSelf = self;
    for (id<PSGroupItem>obj in items) {
        obj.parant = self;
        [obj setColumnWidthBlock:^CGFloat(NSInteger column) {
            CGFloat width = 0.0f;
            if (weakSelf.columnWidthBlock) {
                width = weakSelf.columnWidthBlock(column);
            }
            return width;
        }];
    }
}

- (BOOL)isExpand {
    return _viewItems.isExpand;
}

// MARK: Getter
- (UIView *)viewContent {
    if (_viewContent == nil) {
        UIView* view = [[UIView alloc] init];
        _viewContent = view;
        
        UIView* superview = view;
        [superview addSubview:self.viewItems];
        [_viewItems mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superview).offset(4.0);
            make.leading.trailing.equalTo(superview);
            make.bottom.equalTo(superview).offset(-4.0);
        }];
    }
    return _viewContent;
}

- (PSGroupView *)viewItems {
    if (_viewItems == nil) {
        PSGroupView* view = [PSGroupView viewForHeader];
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
            [weakSelf switchExpand:![weakSelf isExpand]];
            [weakSelf.parant reloadChildren];
            if (weakSelf.touchedBlock) {
                weakSelf.touchedBlock(weakSelf);
            }
        }];
        _viewItems = view;
    }
    return _viewItems;
}

// MARK: TCSOPItem
@synthesize columnWidthBlock;
@synthesize parant;
@synthesize touchedBlock;

- (NSInteger)digitalDepth {
    return 0;
}

- (nonnull UIView *)getView {
    return self.viewContent;
}

- (NSArray<id<PSGroupItem>> *)items {
    return self.subItems;
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
    return self.values;
}

- (BOOL)isBottomLevelItem {
    return NO;
}

@end
