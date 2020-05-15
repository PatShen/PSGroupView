//
//  TCSOPHeaderModel.m
//  TospurHouseBusiness
//
//  Created by shenwenxin on 2020/5/9.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import "TCSOPHeaderModel.h"
#import "TCSOPItemView.h"

@interface TCSOPHeaderModel ()

@property (nonatomic, strong) NSMutableArray<NSString*>* titles;

@property (nonatomic, strong) NSMutableArray<id<TCSOPItem>>* subItems;

@property (nonatomic, strong) UIView* viewContent;

@property (nonatomic, strong) UIView* viewBg;

@property (nonatomic, strong) UIView* viewBgShadow;

@property (nonatomic, strong) TCSOPItemView* viewItems;

@end

@implementation TCSOPHeaderModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.subItems = @[].mutableCopy;
    }
    return self;
}

+ (instancetype)modelWithTitles:(NSArray<NSString *> *)titles {
    TCSOPHeaderModel* model = [[TCSOPHeaderModel alloc] init];
    model.titles = [NSMutableArray arrayWithArray:titles];
    return model;
}

- (void)loadItems:(NSArray<id<TCSOPItem>> *)items {
    self.subItems = [NSMutableArray arrayWithArray:items];
    for (id<TCSOPItem>obj in items) {
        obj.parant = self;
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
        
        UIView* superview = _viewContent;
        [superview addSubview:self.viewBgShadow];
        [superview addSubview:self.viewBg];
        [_viewBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superview);
        }];
        [_viewBgShadow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superview);
        }];
        _viewBgShadow.layer.cornerRadius = 8.0;
        _viewBgShadow.layer.shadowRadius = 8.0;
        _viewBg.layer.cornerRadius = 8.0;
        _viewBg.layer.masksToBounds = YES;
    }
    return _viewContent;
}

- (UIView *)viewBg {
    if (_viewBg == nil) {
        UIView* view = [[UIView alloc] init];
        [view setBackgroundColor:UIColor.whiteColor];
        _viewBg = view;
        
        UIView* superview = _viewBg;
        [superview addSubview:self.viewItems];
        [_viewItems mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superview);
            make.leading.trailing.equalTo(superview);
            make.bottom.equalTo(superview);
        }];
    }
    return _viewBg;
}

- (UIView *)viewBgShadow {
    if (_viewBgShadow == nil) {
        UIView* view = [[UIView alloc] init];
        view.layer.backgroundColor = UIColor.whiteColor.CGColor;
        view.layer.shadowColor = UIColorHex_Alpha(0x2E448A, 0.06f).CGColor;
        view.layer.shadowOffset = CGSizeMake(0,2);
        view.layer.shadowOpacity = 1;
        _viewBgShadow = view;
    }
    return _viewBgShadow;
}

- (TCSOPItemView *)viewItems {
    if (_viewItems == nil) {
        TCSOPItemView* view = [TCSOPItemView viewForHeader];
        [view manualConstraintTableView];
        __weak typeof(self) weakSelf = self;
        [view setLoadDataBlock:^id<TCSOPItem> _Nonnull{
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
            [weakSelf switchExpand];
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

- (NSArray<id<TCSOPItem>> * _Nullable)items {
    return self.subItems;
}

- (void)reloadChildren {
    [_viewItems reloadChildren];
}

- (void)reloadView {
    [_viewItems reloadData];
}

- (void)switchExpand {
    [_viewItems switchExpand];
}

- (nonnull NSArray<NSString *> *)textValues {
    return self.titles;
}

- (BOOL)isBottomLevelItem {
    return NO;
}

@end
