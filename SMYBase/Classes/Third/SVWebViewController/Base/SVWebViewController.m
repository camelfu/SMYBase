//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "SMYNotReachableView.h"
#import "SMYImageTool.h"
#import "SMYDeviceTool.h"

@interface SVWebViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) NSURLRequest      *request;
@property (nonatomic, strong) WKWebView         *webView;

@property (nonatomic, strong) NJKWebViewProgressView *progressView;//加载进度条
@property (nonatomic, strong) SMYNotReachableView    *notReachableView;//断网空页面

@end


@implementation SVWebViewController

#pragma mark - Initialization

- (void)dealloc {
    if (_webView) {
        [self dInitWebViewConfigurationInit:_webView.configuration];
        [_webView stopLoading];
        _webView.navigationDelegate = nil;
        [_webView removeObserver:self forKeyPath:@"title"];
        [_webView removeObserver:self forKeyPath:@"loading"];
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)loadRequest:(NSURLRequest*)request {
    self.request = request;
    if (request.URL) {
        if (self.isViewLoaded) {
            [self.webView loadRequest:request];
        }
    }
}

- (void)reloadPageWithURL:(NSURL*)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化页面加载进度条
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = CGRectMake(0, 0, kWindowWidth, 44);
    if (self.navigationController) {
        navigationBarBounds = self.navigationController.navigationBar.bounds;
    }
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.progressView.progress = 0.0;
    
    self.webView.frame = self.view.bounds;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webView];
    self.notReachableView.frame = self.webView.bounds;
    [self.view addSubview:self.notReachableView];
    self.notReachableView.hidden = YES;
    NetworkStatus status = [[SMYDeviceTool shareInstance].reachability currentReachabilityStatus];
    if (NotReachable == status) {
        self.notReachableView.hidden = NO;
    } else if (self.request) {
        [self loadRequest:self.request];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView.frame = barFrame;
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    if ((!self.notReachableView.superview || self.notReachableView.isHidden) && !self.webView.backForwardList.currentItem && self.request) {
        [self loadRequest:self.request];
    }
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.view endEditing:YES];
}

@dynamic webViewCurrentUrl, canGoBackWebSite;
- (NSURL *)webViewCurrentUrl {
    return self.webView.backForwardList.currentItem.URL;
}

- (BOOL)canGoBackWebSite {
    NetworkStatus status = [[SMYDeviceTool shareInstance].reachability currentReachabilityStatus];
    if (NotReachable == status) {
        return NO;
    }
    if (!self.notReachableView.isHidden) {//上个请求加载失败
        if (self.webView.backForwardList.currentItem) {
            return YES;
        }
    }
    return self.webView.canGoBack;
}

- (BOOL)goBackWebSite {
    NetworkStatus status = [[SMYDeviceTool shareInstance].reachability currentReachabilityStatus];
    if (NotReachable == status) {
        return NO;
    }
    if (!self.notReachableView.isHidden) {//当前的请求加载失败
        self.notReachableView.hidden = YES;
        if (self.webView.backForwardList.currentItem) {
            [self.webView reload];
            return YES;
        }
    }
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return YES;
    }
    return NO;
}

#pragma mark - Getters

- (SMYNotReachableView *)notReachableView {
    if (!_notReachableView) {
        _notReachableView = [[SMYNotReachableView alloc] initWithFrame:self.view.frame];
        _notReachableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_notReachableView setDelegate:(id<SMYNotReachableViewDelegate>)self];
    }
    return _notReachableView;
}

- (WKWebView *)webView {
    if(!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        [self webViewConfigurationInit:configuration];
        
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:configuration];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

#pragma mark - private

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"loading"]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:self.webView.loading];
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }
}

#pragma mark - SMYNotReachableViewDelegate

- (void)reloadDidClicked {//重新加载当前页面
    if (!self.notReachableView.isHidden && self.request) {//当前加载失败了
        [self.webView loadRequest:self.request];//加载之前的请求
    } else if (self.webView.backForwardList.currentItem) {
        [self.webView reload];
    } else if (self.request) {
        [self.webView loadRequest:self.request];
    }
}

#pragma mark - Subclass overide
- (void)webViewConfigurationInit:(WKWebViewConfiguration *)configuration {}

- (void)dInitWebViewConfigurationInit:(WKWebViewConfiguration *)configuration {}

- (void)webViewWillTryToLoadRequest:(NSURLRequest *)request {}

- (void)webViewWillStartLoadNewNavigation:(WKNavigationAction *)navigationAction {}

- (void)webViewDidStartLoadNewRequest {}

- (void)webViewDidFinishLoad {}

- (BOOL)webViewDidFailLoadWithError:(NSError *)error { return YES; }

- (void)decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if (decisionHandler) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)didReceiveScriptMessage:(WKScriptMessage *)message {}

#pragma mark - WebViewDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    __weak SVWebViewController *weakSelf = self;
    NSURLRequest *request = navigationAction.request;
    [self webViewWillTryToLoadRequest:request];
    void (^selfDecisionHandler)(WKNavigationActionPolicy) = ^(WKNavigationActionPolicy policy) {
        if (policy == WKNavigationResponsePolicyAllow && ([request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"])) {
            BOOL isFragmentJump = NO;
            if (request.URL.fragment) {
                NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
                isFragmentJump = [nonFragmentURL isEqualToString:webView.backForwardList.currentItem.URL.absoluteString];
            }
            if (!isFragmentJump && [request.mainDocumentURL isEqual:request.URL]) {
                weakSelf.request = request;
            }
            [weakSelf webViewWillStartLoadNewNavigation:navigationAction];
        }
        decisionHandler(policy);
    };
    [self decidePolicyForNavigationAction:navigationAction decisionHandler:selfDecisionHandler];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    [self decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NetworkStatus status = [[SMYDeviceTool shareInstance].reachability currentReachabilityStatus];
    if (status == NotReachable) {
        self.notReachableView.hidden = NO;
    } else {
        self.notReachableView.hidden = YES;
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    [self webViewDidStartLoadNewRequest];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self webViewDidFinishLoad];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if ([self webViewDidFailLoadWithError:error] && NSURLErrorCancelled != error.code) {
        //加载失败跳,显示断网空页面
        self.notReachableView.hidden = NO;
    }
}

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
            forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *viewCtl = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [viewCtl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) {
            completionHandler();
        }
    }]];
    [self presentViewController:viewCtl animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *viewCtl = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [viewCtl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) {
            completionHandler(YES);
        }
    }]];
    [viewCtl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) {
            completionHandler(NO);
        }
    }]];
    [self presentViewController:viewCtl animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *viewCtl = [UIAlertController alertControllerWithTitle:@"" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [viewCtl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if (defaultText) {
            textField.text = defaultText;
        }
    }];
    __weak UIAlertController *weakAlertViewCtl = viewCtl;
    [viewCtl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) {
            completionHandler([(UITextField *)weakAlertViewCtl.textFields.firstObject text]);
        }
    }]];
    [viewCtl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) {
            completionHandler(nil);
        }
    }]];
    [self presentViewController:viewCtl animated:YES completion:nil];
}

@end
