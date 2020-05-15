//
//  TCDepModel.h
//  TCExpandTableView
//
//  Created by shenwenxin on 2020/5/8.
//  Copyright © 2020 tospur co,.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCExpandTableViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCDepModel : NSObject <TCExpandTableViewLevel>

@property (nonatomic, assign) BOOL expand;

@end

NS_ASSUME_NONNULL_END
