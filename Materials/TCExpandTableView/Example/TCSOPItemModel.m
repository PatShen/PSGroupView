//
//  TCSOPItemModel.m
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import "TCSOPItemModel.h"
#import "TCSOPItemView.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>

@interface TCSOPItemModel () <YYModel>

@property (nonatomic, copy) NSString* name;

@property (nonatomic, strong) NSMutableArray<NSString*>* values;

@property (nonatomic, strong) NSMutableArray<TCSOPItemModel*>* subItems;

@property (nonatomic, assign) NSInteger depth;

@property (nonatomic, strong) UIView* viewContent;

@property (nonatomic, strong) TCSOPItemView* viewItems;

@end

@implementation TCSOPItemModel

- (NSArray<NSString *> *)textValues {
    NSMutableArray* array = @[].mutableCopy;
    [array addObject:_name];
    [array addObjectsFromArray:_values];
    return array;
}

- (NSArray<TCSOPItemModel *> *)items {
    return _subItems;
}

- (NSInteger)digitalDepth {
    return self.depth;
}

- (UIView *)getView {
    return self.viewContent;
}

- (void)reloadView {
    [_viewItems reloadData];
}

- (void)reloadChildren {
    [_viewItems reloadChildren];
}

- (void)switchExpand:(BOOL)animated {
    [self switchExpand];
}

- (void)switchExpand {
    [_viewItems switchExpand];
}


// MARK: Getter
- (NSInteger)depth {
    NSInteger value = 0;
    TCSOPItemModel* model = self.parant;
    while (model) {
        model = model.parant;
        value++;
    }
    return value;
}

- (UIView *)viewContent {
    if (_viewContent == nil) {
        UIView* view = [[UIView alloc] init];
        _viewContent = view;
        
        UIView* superview = _viewContent;
        [superview addSubview:self.viewItems];
        [_viewItems mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superview).offset(0.0);
            make.leading.trailing.equalTo(superview);
            make.bottom.equalTo(superview);
        }];
    }
    return _viewContent;
}

- (TCSOPItemView *)viewItems {
    if (_viewItems == nil) {
        TCSOPItemView* view = nil;
        if (self.digitalDepth == 0) {
            view = [TCSOPItemView viewForHeader];
        }
        else {
            view = [TCSOPItemView viewForDepartment];
        }
        
        __weak typeof(self) weakSelf = self;
        [view setLoadDataBlock:^TCSOPItemModel * _Nonnull{
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
            [weakSelf switchExpand:NO];
            [weakSelf.parant reloadChildren];
            if (weakSelf.touchedBlock) {
                weakSelf.touchedBlock(weakSelf);
            }
        }];
        _viewItems = view;
    }
    return _viewItems;
}

// MARK: YYModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"subItems":[TCSOPItemModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([self.subItems isKindOfClass:[NSArray class]] && self.subItems.count > 0) {
        for (TCSOPItemModel* sub in self.subItems) {
            sub.parant = self;
            __weak typeof(self) weakSelf = self;
            [sub setColumnWidthBlock:^CGFloat(NSInteger column) {
                return weakSelf.columnWidthBlock(column);
            }];
            [sub setTouchedBlock:^(id<TCSOPItem>  _Nonnull obj) {
                [weakSelf.parant reloadChildren];
                if (weakSelf.touchedBlock) {
                    weakSelf.touchedBlock(obj);
                }
            }];
        }
    }
    return YES;
}

@end
