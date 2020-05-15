//
//  TCSOPItemView.m
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import "TCSOPItemView.h"
#import <Masonry/Masonry.h>

@interface TCSOPItemView () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat tableHeight_;
}

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) UIFont* textFont;

@property (nonatomic, strong) UIColor* textColor;

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, strong) UIView* viewLine;

@property (nonatomic, strong) UITableView* tblList;

@property (nonatomic, weak) id<TCSOPItem> item;

@property (nonatomic, strong) NSMutableArray* labelsArray;

@end

@implementation TCSOPItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.labelsArray = @[].mutableCopy;
        [self defaultConfig];
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchedActionButton:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)defaultConfig {
    self.rowHeight = 40.0;
    self.textFont = [UIFont systemFontOfSize:14.0];
    self.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
}

- (void)reloadData {
    if (!self.loadDataBlock) {
        return;
    }
    id model = self.loadDataBlock();
    if ([self.item isEqual:model]) {
        return;
    }
    self.item = model;
    NSArray* values = [model textValues];
    UIView* lastView = nil;
    [_labelsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSString* text in values) {
        NSInteger idx = [values indexOfObject:text];
        if (self.columnWidthBlock) {
            CGFloat columnWidth = self.columnWidthBlock(idx);
            UILabel* lbl = [self createLabel];
            [lbl setText:text];
            [_labelsArray addObject:lbl];
            [self addSubview:lbl];
            UIView* superview = self;
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(superview);
                make.size.mas_equalTo(CGSizeMake(columnWidth, self.rowHeight));
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
    UIView* superview = self;
    if (_viewLine && lastView) {
        [_viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(1.0);
            make.leading.trailing.equalTo(superview);
            make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
        }];
    }
    if (![_tblList.superview isEqual:superview]) {
        [superview addSubview:self.tblList];
        [_tblList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewLine.mas_bottom);
            make.leading.trailing.equalTo(superview);
            make.bottom.equalTo(superview);
            make.height.mas_equalTo(0);
        }];
    }
}

- (void)reloadChildren {
    if ([self.item.items count] > 0) {
        [_tblList setHidden:NO];
        [_tblList mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
        }];
        [_tblList reloadData];
        [_tblList layoutIfNeeded];
        CGSize size = _tblList.contentSize;
        tableHeight_ = size.height;
        if (_isExpand) {
            [_tblList mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(size.height);
            }];
        }
        else {
            [_tblList mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.0);
            }];
        }
    }
    else {
        [_tblList setHidden:YES];
        [_tblList mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.0);
        }];
    }
}

- (void)switchExpand {
    if (self.item.items.count <= 0) {
        return;
    }
    self.isExpand = !self.isExpand;
    [self reloadChildren];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

// MARK: 内部方法
- (UILabel*)createLabel {
    UILabel* lbl = [[UILabel alloc] init];
    [lbl setBackgroundColor:UIColor.clearColor];
    [lbl setFont:self.textFont];
    [lbl setTextColor:self.textColor];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setUserInteractionEnabled:NO];
    return lbl;
}

- (void)configureSeparatorLine {
    [self addSubview:self.viewLine];
}

- (void)didTouchedActionButton:(id)sender {
    if (self.touchedBlock) {
        self.touchedBlock();
    }
}

// MARK: Getter
- (UIView *)viewLine {
    if (_viewLine == nil) {
        UIView* view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0]];
        _viewLine = view;
    }
    return _viewLine;
}

- (UITableView *)tblList {
    if (_tblList == nil) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10);
        UITableView* tbl = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [tbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tbl setDataSource:self];
        [tbl setDelegate:self];
        _tblList = tbl;
    }
    return _tblList;
}

// MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.item items].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identifier = @"items";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    id model = [self.item items][indexPath.row];
    UIView* view = [model getView];
    if (![cell.contentView.subviews containsObject:view]) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIView* superview = cell.contentView;
        [superview addSubview:view];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(superview);
            make.bottom.equalTo(superview).priorityHigh();
        }];
        [model reloadView];
    }
    
    return cell;
}

// MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end

// MARK: - Category
@implementation TCSOPItemView (Creation)

+ (instancetype)viewForHeader {
    TCSOPItemView* view = [[TCSOPItemView alloc] init];
    [view setBackgroundColor:UIColor.whiteColor];
    view.textFont = [UIFont boldSystemFontOfSize:14.0];
    view.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [view configureSeparatorLine];
    return view;
}


+ (instancetype)viewForDepartment {
    TCSOPItemView* view = [[TCSOPItemView alloc] init];
    [view setBackgroundColor:UIColor.whiteColor];
    view.textFont = [UIFont systemFontOfSize:13.0];
    view.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [view configureSeparatorLine];
    [view.tblList setScrollEnabled:NO];
    return view;
}

@end
