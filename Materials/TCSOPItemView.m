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

@property (nonatomic, strong) UIColor* bgColor;

@property (nonatomic, strong) UIView* viewContent;

@property (nonatomic, strong) UIImageView* imgvStatus;

@property (nonatomic, strong) UIView* viewLine;

@property (nonatomic, strong) UITableView* tblList;

@property (nonatomic, weak) id<TCSOPItem> item;

@property (nonatomic, strong) NSMutableArray* labelsArray;
/// 标记是否手动约束 tableView 的高度
@property (nonatomic, assign) BOOL isConstraintTableViewHeight;

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
        self.isConstraintTableViewHeight = YES;
    }
    return self;
}

- (void)defaultConfig {
    self.rowHeight = 40.0;
    self.textFont = [UIFont systemFontOfSize:14.0];
    self.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.bgColor = UIColor.clearColor;
    [self addSubview:self.viewContent];
    [_viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.bottom.lessThanOrEqualTo(self);
    }];
}

- (void)reloadData {
    if (!self.loadDataBlock) {
        return;
    }
    id model = self.loadDataBlock();
    self.item = model;
    NSArray* values = [model textValues];
    UIView* lastView = nil;
    [_labelsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imgvStatus.superview removeFromSuperview];
    for (NSInteger idx = values.count-1; idx >= 0; idx--) {
        NSString* text = values[idx];
        if (self.columnWidthBlock) {
            CGFloat columnWidth = self.columnWidthBlock(idx);
            UILabel* lbl = [self createLabel];
            [lbl setText:text];
            [_labelsArray addObject:lbl];
            UIView* superview = self.viewContent;
            [self.viewContent setBackgroundColor:self.bgColor];
            [superview addSubview:lbl];
            CGFloat firstItemOffset = CONTENT_PIXEL(14.0);
            CGFloat firstItemOrigin = CONTENT_PIXEL(20.0);
            NSInteger depth = [model digitalDepth];
            CGFloat leadingOffset = 0.0;
            if (depth != 0 && idx == 0) {
                [lbl setTextAlignment:NSTextAlignmentLeft];
                if ([model isBottomLevelItem]) {
                    if (depth > 0) {
                        leadingOffset = firstItemOrigin+firstItemOffset*(depth-1);
                    }
                }
                else {
                    leadingOffset = firstItemOrigin+firstItemOffset*depth;
                    UIView* view = [self createExpandStatusView];
                    [superview addSubview:view];
                    CGSize size = CGSizeMake(12.0, 12.0);
                    [view.layer setCornerRadius:size.height/2.0];
                    [view.layer setMasksToBounds:YES];
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(lbl);
                        make.trailing.equalTo(lbl.mas_leading).offset(-2.0);
                        make.size.mas_equalTo(size);
                    }];
                }
            }
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(superview);
                if (idx == 0) {
                    make.trailing.equalTo(lastView.mas_leading);
                    if (depth == 0) {
                        make.height.mas_equalTo(self.rowHeight);
                        make.leading.equalTo(superview);
                    }
                    else {
                        make.leading.equalTo(superview).offset(leadingOffset);
                    }
                }
                else {
                    make.size.mas_equalTo(CGSizeMake(columnWidth, self.rowHeight));
                    if (lastView) {
                        make.trailing.equalTo(lastView.mas_leading);
                    }
                    else {
                        make.trailing.equalTo(superview);
                    }
                }
            }];
            lastView = lbl;
        }
    }
    if (_viewLine && ![_viewLine.superview isEqual:self.viewContent]) {
        UIView* superview = self.viewContent;
        [superview addSubview:_viewLine];
        [_viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(superview);
            make.leading.trailing.equalTo(superview);
            make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
        }];
    }
    if (_tblList && ![_tblList.superview isEqual:self]) {
        UIView* superview = self;
        [superview addSubview:_tblList];
        [_tblList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewContent.mas_bottom);
            make.leading.trailing.equalTo(superview);
            make.bottom.equalTo(superview);
            make.height.mas_equalTo(0);
        }];
    }
    [self reloadChildren];
}

- (void)reloadChildren {
    if (self.isConstraintTableViewHeight) {
        if ([self.item.items count] > 0) {
            if (_isExpand) {
                // 这行代码为了解决 content size 计算不准确的问题
                [_tblList mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
                }];
                [_tblList layoutIfNeeded];
                [_tblList setHidden:NO];
                [_tblList reloadData];
                [_tblList layoutIfNeeded];
                CGSize size = _tblList.contentSize;
                tableHeight_ = size.height;
                [_tblList mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(size.height);
                }];
            }
            else {
                [_tblList setHidden:YES];
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
    else {
        [_tblList setHidden:NO];
        [_tblList reloadData];
        UIView* superview = _tblList.superview;
        [_tblList mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewContent.mas_bottom);
            make.leading.trailing.equalTo(superview);
            make.bottom.equalTo(superview);
        }];
    }
}

- (void)switchExpand {
    [self switchExpand:!_isExpand];
}

- (void)switchExpand:(BOOL)isExpand {
    if (self.item.items.count <= 0) {
        return;
    }
    _isExpand = isExpand;
    UIImage* image = kImageName(@"msop_icon_plus");
    if (_isExpand) {
        image = kImageName(@"msop_icon_minus");
    }
    [_imgvStatus setImage:image];
    [self reloadChildren];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)manualConstraintTableView {
    self.isConstraintTableViewHeight = NO;
}

// MARK: 内部方法
- (UILabel*)createLabel {
    UILabel* lbl = [[UILabel alloc] init];
    [lbl setFont:self.textFont];
    [lbl setTextColor:self.textColor];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setUserInteractionEnabled:NO];
    return lbl;
}

- (UIView*)createExpandStatusView {
    UIView* view = [[UIView alloc] init];
    [view setBackgroundColor:Pub_MainColor];
    
    UIImageView* imgv = [[UIImageView alloc] initWithImage:kImageName(@"msop_icon_plus")];
    [view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(6.0, 6.0));
    }];
    self.imgvStatus = imgv;
    
    return view;
}

- (UILabel*)createExpandStatusLabel {
    UILabel* lbl = [[UILabel alloc] init];
    [lbl setBackgroundColor:Pub_MainColor];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:UIColor.whiteColor];
    [lbl setFont:[UIFont systemFontOfSize:8.0]];
    return lbl;
}

- (void)configureSeparatorLine {
    if (self.viewLine) {
        
    }
}

- (void)configureTableview {
    if (self.tblList) {
        
    }
}

- (void)didTouchedActionButton:(id)sender {
    if (self.touchedBlock) {
        self.touchedBlock();
    }
}

// MARK: Getter
- (UIView *)viewContent {
    if (_viewContent == nil) {
        UIView* view = [[UIView alloc] init];
        [view setBackgroundColor:self.bgColor];
        _viewContent = view;
    }
    return _viewContent;
}

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
        [tbl setBackgroundColor:UIColor.clearColor];
        [tbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tbl setDataSource:self];
        [tbl setDelegate:self];
        [tbl setShowsHorizontalScrollIndicator:NO];
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
        [cell.contentView setBackgroundColor:UIColor.clearColor];
        [cell setBackgroundColor:UIColor.clearColor];
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
    view.textFont = [UIFont boldSystemFontOfSize:14.0];
    view.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [view setBgColor:UIColor.whiteColor];
    [view configureSeparatorLine];
    [view configureTableview];
    return view;
}


+ (instancetype)viewForDepartment {
    TCSOPItemView* view = [[TCSOPItemView alloc] init];
    view.textFont = [UIFont systemFontOfSize:13.0];
    view.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [view setBgColor:UIColor.whiteColor];
    [view configureSeparatorLine];
    [view configureTableview];
    [view.tblList setScrollEnabled:NO];
    return view;
}

+ (instancetype)viewForPerson {
    TCSOPItemView* view = [[TCSOPItemView alloc] init];
    [view setBgColor:Pub_BackgroundColor];
    view.textFont = [UIFont systemFontOfSize:13.0];
    view.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    return view;
}

@end
