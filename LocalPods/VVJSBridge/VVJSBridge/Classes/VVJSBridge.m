//
// Created by 赵江明 on 2021/10/22.
// Copyright (c) 2021 chinaxxren. All rights reserved.
//

#import "VVJSBridge.h"

#ifdef DEBUG
#define VVJSBridgeLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define VVJSBridgeLog(...)
#endif

@implementation VVJSBridge

+ (void)cleanHandler:(VVJSBridge *)handler {
    if (handler.webView) {
        [handler.webView evaluateJavaScript:@"VVJSBridge.removeAllCallBacks();" completionHandler:nil];//删除所有的回调事件
        [handler.webView.configuration.userContentController removeScriptMessageHandlerForName:VVJSBridgeName];
    }
    handler = nil;
}

+ (NSString *)handlerJS {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"VVJSBridge" ofType:@"js"];
    NSString *handlerJS = [NSString stringWithContentsOfFile:path encoding:kCFStringEncodingUTF8 error:nil];
    handlerJS = [handlerJS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return handlerJS;
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wincompatible-pointer-types-discards-qualifiers"
    if ([message.name isEqualToString:VVJSBridgeName]) {
#pragma clang diagnostic pop
        NSString *plugin = [message.body jk_stringForKey:@"plugin"];
        NSString *funcName = [message.body jk_stringForKey:@"func"];
        NSDictionary *params = [message.body jk_dictionaryForKey:@"params"];
        NSString *successCallBackID = [message.body jk_stringForKey:@"successCallbackId"];
        NSString *failureCallBackID = [message.body jk_stringForKey:@"failureCallbackId"];

        funcName = [NSString stringWithFormat:@"%@:successCallback:failureCallback:", funcName];
        __weak typeof(self) weakSelf = self;
        [self interactWithPlugin:plugin funcName:funcName params:params success:^(id response) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf _jkCallJSCallBackWithCallBackName:successCallBackID response:response];
            }
        }                failure:^(id response) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf _jkCallJSCallBackWithCallBackName:failureCallBackID response:response];
            }
        }];
    }
}

- (void)interactWithPlugin:(NSString *)plugin
                  funcName:(NSString *)funcName
                    params:(NSDictionary *)params
                   success:(void (^)(id response))successCallBack
                   failure:(void (^)(id response))failureCallBack {
    SEL selector = NSSelectorFromString(funcName);
    Class realHandler = NSClassFromString(plugin);
    if ([realHandler respondsToSelector:selector]) {
        IMP imp = [realHandler methodForSelector:selector];
        void (*func)(id, SEL, id, id, id) = (void *) imp;
        func(realHandler, selector, params, successCallBack, failureCallBack);
    } else if ([self.delegate respondsToSelector:selector]) {
        IMP imp = [self.delegate methodForSelector:selector];
        void (*func)(id, SEL, id, id, id) = (void *) imp;
        func(self.delegate, selector, params, successCallBack, failureCallBack);
    } else {
        if (failureCallBack) {
            failureCallBack([NSString stringWithFormat:@"%@ unsupport %@", plugin, funcName]);
        }
    }
}

- (void)_jkCallJSCallBackWithCallBackName:(NSString *)callBackName response:(id)response {
    WKWebView *weakWebView = _webView;
    if ([response isKindOfClass:[NSDictionary class]] || [response isKindOfClass:[NSArray class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];

        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        response = jsonStr;
    }
    
    NSString *js = [NSString stringWithFormat:@"VVJSBridge.callBack('%@','%@');", callBackName, response];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakWebView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError *_Nullable error) {
            VVJSBridgeLog(@"VVJSBridge.callBack: %@\n response: %@", callBackName, response);
        }];
    });
}

- (void)evaluateJavaScript:(NSString *)js
                 completed:(void (^)(id data, NSError *error))completed {
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError *_Nullable error) {
        if (completed) {
            completed(data, error);
        }
    }];
}

- (id)synEvaluateJavaScript:(NSString *)js
                      error:(NSError **)error {
    __block id result = nil;
    __block BOOL success = NO;
    __block NSError *resultError = nil;
    [self.webView evaluateJavaScript:js completionHandler:^(id tmpResult, NSError *_Nullable tmpError) {
        if (!tmpError) {
            result = tmpResult;
            success = YES;
        } else {
            resultError = tmpError;
        }
        success = YES;
    }];

    while (!success) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if (error != NULL) {
        *error = resultError;
    }
    return result;
}

@end
