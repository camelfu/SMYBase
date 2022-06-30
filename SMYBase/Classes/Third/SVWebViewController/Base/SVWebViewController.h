//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <WebKit/WebKit.h>

@interface SVWebViewController : UIViewController

@property (nonatomic, readonly) WKWebView       *webView;
@property (nonatomic, readonly) NSURL           *webViewCurrentUrl;
@property (nonatomic, readonly) NSURLRequest    *request;
@property (nonatomic, readonly) BOOL            canGoBackWebSite;//是否能够返回前一个页面

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

/**
 *  加载一个指定页面
 */
- (void)reloadPageWithURL:(NSURL*)URL;

/**
 返回上一个链接,成功返回YES
 */
- (BOOL)goBackWebSite;

//以下接口用于给子类重写-------------------------------------------------------------------------
/**
 加载并打开一个请求
 */
- (void)loadRequest:(NSURLRequest*)request;

/**
 可以对webView初始化时进行一些配置，包括增加JS交互的MessageHandler
 */
- (void)webViewConfigurationInit:(WKWebViewConfiguration *)configuration;

/**
 注销相关的配置
 */
- (void)dInitWebViewConfigurationInit:(WKWebViewConfiguration *)configuration;

/**
 即将尝试加载的回调，即将要开始decidePolicyForNavigationAction
 */
- (void)webViewWillTryToLoadRequest:(NSURLRequest *)request;

/**
 用于决定是否处理某个请求
 */
- (void)decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

/**
 用于决定是否处理某个请求返回的响应
 */
- (void)decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;

/**
 即将开始加载的回调
 */
- (void)webViewWillStartLoadNewNavigation:(WKNavigationAction *)navigationAction;

/**
 开始加载的回调
 */
- (void)webViewDidStartLoadNewRequest;

/**
 加载结束的回调
 */
- (void)webViewDidFinishLoad;
- (BOOL)webViewDidFailLoadWithError:(NSError *)error;

/**
 处理收到的来自web端的调用
 */
- (void)didReceiveScriptMessage:(WKScriptMessage *)message;
//不要重写覆盖下面这个接口
//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end
