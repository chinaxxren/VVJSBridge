//
// Created by 赵江明 on 2021/10/22.
// Copyright (c) 2021 chinaxxren. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestPluginA : NSObject

+ (void)getNativeInfo:(NSDictionary *)params successCallback:(void (^)(id response))successCallBack failureCallback:(void (^)(id response))failureCallback;

@end

NS_ASSUME_NONNULL_END
