//
//  ViewController.m
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/19.
//  Copyright © 2020 swx. All rights reserved.
//

#import "ViewController.h"
#import "PSGroupHeaderModel.h"
#import "PSGroupDepModel.h"
#import <YYModel/YYModel.h>
#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) PSGroupHeaderModel* mdlHeader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self loadData];
    
    UIView* view = [self.mdlHeader getView];
    [self.view addSubview:view];
    UIView* superview = self.view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(superview.mas_safeAreaLayoutGuideLeft).offset(10.0);
            make.top.equalTo(superview.mas_safeAreaLayoutGuideTop).offset(10.0);
            make.right.equalTo(superview.mas_safeAreaLayoutGuideRight).offset(-10.0);
            make.bottom.lessThanOrEqualTo(superview.mas_safeAreaLayoutGuideBottom).offset(-10.0);
        } else {
            make.top.equalTo(superview).offset(10.0);
            make.leading.equalTo(superview).offset(10.0);
            make.trailing.equalTo(superview).offset(-10.0);
            make.bottom.lessThanOrEqualTo(superview).offset(-10.0);
        }
    }];
    [_mdlHeader reloadView];
    [self.mdlHeader switchExpand:YES];
}

- (void)loadData {
    [self.mdlHeader loadItems:[self loadTestData]];
    [self.mdlHeader reloadView];
}

- (NSArray*)loadTestData {
    NSArray* array = @[
        @{@"name":@"上海二公司",
          @"values":@[@"20",@"60",@"4.5"],
          @"subItems":@[@{@"name":@"一片区",
                          @"values":@[@"20",@"60",@"4.5"],
                          @"members":@[@{@"name":@"啊啊啊",
                                         @"values":@[@"20",@"60",@"4.5"]},
                                       @{@"name":@"小李子",
                                         @"values":@[@"20",@"60",@"4.5"]},
                          ],
                           },
                       ]
          },
        @{@"name":@"上海三公司",
          @"values":@[@"25",@"80",@"4.5"],
          @"subItems":@[@{@"name":@"子部门1",
                          @"values":@[@"25",@"80",@"4.5"],
                        },
                        @{@"name":@"子部门2",
                          @"values":@[@"25",@"80",@"4.5"],
                          @"subItems":@[
                                  @{@"name":@"子部门1",
                                    @"values":@[@"25",@"80",@"4.5"],
                                    @"members":@[@{@"name":@"大张子",
                                                   @"values":@[@"20",@"60",@"4.5"]},
                                                 @{@"name":@"狗蛋",
                                                   @"values":@[@"20",@"60",@"4.5"]},
                                    ],
                                  },
                          ]
                        },
          ],
          @"members":@[
                  @{@"name":@"小1",
                    @"values":@[@"1",@"2",@"3"]
                  },
          ]
         }
    ];
    NSMutableArray* result = @[].mutableCopy;
    for (NSDictionary* dict in array) {
        PSGroupDepModel* model = [PSGroupDepModel yy_modelWithDictionary:dict];
        [result addObject:model];
    }
    return result;
}

- (PSGroupHeaderModel *)mdlHeader {
    if (_mdlHeader == nil) {
        PSGroupHeaderModel* model = [PSGroupHeaderModel modelWithTitles:@[@"标题1",@"标题2",@"标题3",@"标题4"]];
        [model setColumnWidthBlock:^CGFloat(NSInteger column) {
            CGFloat width = 0.0;
            switch (column) {
                case 0:
                    width = 116.0;
                    break;
                case 1:
                    width = 72.5;
                    break;
                case 2:
                    width = 72.5;
                    break;
                case 3:
                    width = 94.0;
                    break;
                default:
                    break;
            }
            return width;
        }];
        __weak typeof(self) weakSelf = self;
        [model setTouchedBlock:^(id<PSGroupItem>  _Nonnull obj) {
            [weakSelf.mdlHeader reloadView];
        }];
        _mdlHeader = model;
    }
    return _mdlHeader;
}

@end
