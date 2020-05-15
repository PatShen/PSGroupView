//
//  ViewController.m
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import "TCSOPItemModel.h"

@interface ViewController ()

@property (nonatomic, strong) TCSOPItemModel* mdlTop;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    self.mdlTop = [self loadTopItem];
    UIView* view = [self.mdlTop getView];
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
    [_mdlTop reloadView];
    [self.mdlTop switchExpand:NO];
}


- (TCSOPItemModel*)loadTopItem {
    NSDictionary* dict = @{@"name":@"团队成员",
                           @"values":@[@"带看次数",@"评价次数",@"平均满意度"],
                           @"subItems":@[@{@"name":@"上海二公司",
                                           @"values":@[@"20",@"60",@"4.5"],
                                           @"subItems":@[@{@"name":@"一片区",
                                                           @"values":@[@"20",@"60",@"4.5"],
                                                           @"subItems":@[@{@"name":@"啊啊啊",
                                                                           @"values":@[@"20",@"60",@"4.5"]}]
                                                            },
                                                        ]
                                           },
                                         @{@"name":@"上海三公司",
                                           @"values":@[@"25",@"80",@"4.5"]
                                          },
                                         @{@"name":@"上海四公司",
                                          @"values":@[@"25",@"80",@"4.5"]
                                         },
                                         @{@"name":@"上海四公司",
                                          @"values":@[@"25",@"80",@"4.5"]
                                         },
                                         @{@"name":@"上海四公司",
                                          @"values":@[@"25",@"80",@"4.5"]
                                         },
                                         @{@"name":@"上海四公司",
                                          @"values":@[@"25",@"80",@"4.5"]
                                         },
                                         @{@"name":@"上海四公司",
                                          @"values":@[@"25",@"80",@"4.5"]
                                         },
                                         @{@"name":@"上海四公司",
                                          @"values":@[@"25",@"80",@"4.5"]
                                         },
                                         @{@"name":@"上海四公司",
                                          @"values":@[@"25",@"80",@"4.5"]
                                         },
                                         
                           ]
    };
    TCSOPItemModel* model = [TCSOPItemModel yy_modelWithDictionary:dict];
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
    [model setTouchedBlock:^(id<TCSOPItem>  _Nonnull obj) {
        [weakSelf.mdlTop reloadView];
    }];
    return model;
}

@end
