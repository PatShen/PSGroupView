//
//  TCExpandTableView.m
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import "TCExpandTableView.h"
#import <Masonry/Masonry.h>

static CGFloat rowHeight = 40.0;

@interface TCExpandTableView () <UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<UILabel*>* titleLabelArray;

@property (nonatomic, strong) UICollectionView* cllList;

@property (nonatomic, strong) UIView* viewHeader;

@property (nonatomic, strong) NSArray* dataSourceArray;

@end

@implementation TCExpandTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabelArray = @[].mutableCopy;
        [self installConstraints];
    }
    return self;
}

- (void)installConstraints {
    UIView* superview = self;
    [superview addSubview:self.viewHeader];
    [superview addSubview:self.cllList];
    
    [_viewHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).offset(10.0);
        make.leading.trailing.equalTo(superview);
    }];
    [_cllList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewHeader.mas_bottom).offset(10.0);
        make.leading.trailing.equalTo(self.viewHeader);
        make.bottom.equalTo(superview);
        make.height.mas_equalTo(10.0).priorityHigh();
    }];
}

- (void)reloadData {
    id<TCExpandTableViewHeader> header = nil;
    if (self.headerBlock) {
        header = self.headerBlock();
    }
    if (header == nil) {
        NSAssert(NO, @"未提供 header");
        return;
    }
    CGFloat width = 0.0;
    NSArray* titles = [header titles];
    [_titleLabelArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_titleLabelArray removeAllObjects];
    UIView* lastView = nil;
    for (NSString* title in titles) {
        NSInteger idx = [titles indexOfObject:title];
        if (self.columnWidthBlock) {
            CGFloat columnWidth = self.columnWidthBlock(idx);
            width += columnWidth;
            UILabel* lbl = [self createLabel];
            [lbl setText:title];
            [_titleLabelArray addObject:lbl];
            [self.viewHeader addSubview:lbl];
            UIView* superview = self.viewHeader;
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(superview);
                make.size.mas_equalTo(CGSizeMake(columnWidth, 35.0));
                if (lastView) {
                    make.leading.equalTo(lastView.mas_trailing);
                }
                else {
                    make.leading.equalTo(superview);
                }
            }];
            lastView = lbl;
        }
    }
    
    [_cllList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height).priorityHigh();
    }];
    [_cllList reloadData];
    [_cllList layoutIfNeeded];
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)_cllList.collectionViewLayout;
    CGSize size = layout.collectionViewContentSize;
    [_cllList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height).priorityHigh();
    }];
}

// MARK: 内部方法
- (UILabel*)createLabel {
    UILabel* lbl = [[UILabel alloc] init];
    [lbl setFont:[UIFont systemFontOfSize:14.0]];
    [lbl setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    return lbl;
}

// MARK: Getter
- (UIView *)viewHeader {
    if (_viewHeader == nil) {
        UIView* view = [[UIView alloc] init];
        _viewHeader = view;
        
        UIView* line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
        UIView* superview = _viewHeader;
        [superview addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(superview);
            make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
        }];
    }
    return _viewHeader;
}

- (UICollectionView *)cllList {
    if (_cllList == nil) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setMinimumLineSpacing:0.0];
        [layout setMinimumInteritemSpacing:0.0];
        
        UICollectionView* cll = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [cll setBackgroundColor:UIColor.clearColor];
        _cllList = cll;
    }
    return _cllList;
}

// MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = 0;
    id<TCExpandTableViewLevel> level = _dataSourceArray[section];
    if (![level isExpanded]) {
        num = _titleLabelArray.count;
    }
    else {
        num = _titleLabelArray.count + [level subLevel].count * _titleLabelArray.count;
    }
    return num;
}

@end
