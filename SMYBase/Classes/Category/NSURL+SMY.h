//
//  NSURL+SMY.h
//  credit
//
//  Created by ChenYong on 06/12/2017.
//  Copyright © 2017 smyfinancial. All rights reserved.
//
// NSURL的扩展方法

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (SMY)

/// 获取链接中的查询参数构成的字典
- (NSDictionary *)queryDictionary;

@end

NS_ASSUME_NONNULL_END
