//
// Created by 赵江明 on 2021/10/22.
// Copyright (c) 2021 chinaxxren. All rights reserved.
//

#import "TestPluginA.h"

@implementation TestPluginA

+ (void)getNativeInfo:(NSDictionary *)params successCallback:(void (^)(id response))successCallback failureCallback:(void (^)(id response))failureCallback {
    NSLog(@"getNativeInfo %@", params);
    if (successCallback) {
        successCallback(@"success !~~");
    }
    if (failureCallback) {
        failureCallback(@"failure !~~");
    }
}

@end
