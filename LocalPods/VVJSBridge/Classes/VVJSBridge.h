//
// Created by 赵江明 on 2021/10/22.
// Copyright (c) 2021 chinaxxren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <webkit/webkit.h>

static NSString *const VVJSBridgeName = @"VVJSBridge";

@interface VVJSBridge : NSObject <WKScriptMessageHandler>

@property(nonatomic, weak) WKWebView *webView;
@property(nonatomic, weak) id delegate;

+ (NSString *)handlerJS;

/**
 清空handler的数据信息， 注入的脚本。绑定事件信息等等
 */
+ (void)cleanHandler:(VVJSBridge *)handler;

/**
 执行js脚本

 @param js js脚本
 @param completed 回调
 */
- (void)evaluateJavaScript:(NSString *)js
                 completed:(void (^)(id data, NSError *error))completed;

/// 执行js脚本，同步返回
/// @param js js脚本
/// @param error 错误
- (id)synEvaluateJavaScript:(NSString *)js
                      error:(NSError **)error;

@end
