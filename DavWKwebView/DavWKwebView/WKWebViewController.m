//
//  WKWebViewController.m
//  DavWKwebView
//
//  Created by MOON FLOWER on 2018/12/11.
//  Copyright © 2018 崔曦. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

#import "WKWebViewJavascriptBridge.h"

@interface WKWebViewController ()<WKUIDelegate>

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)UIProgressView*progressView;

@property(nonatomic,strong)WKWebViewJavascriptBridge*webViewBridge;
@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWKWebView];
   [self registLocationFunction];
    // Do any additional setup after loading the view.
}

- (void)initWKWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"test.html" ofType:nil];
    NSString *localHtml = [NSString stringWithContentsOfFile:urlStr encoding:NSUTF8StringEncoding error:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.webView loadHTMLString:localHtml baseURL:fileURL];
    
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
}


-(WKWebViewJavascriptBridge*)webViewBridge{
    if (!_webViewBridge) {
        _webViewBridge=[WKWebViewJavascriptBridge bridgeForWebView:self.webView];
        [_webViewBridge setWebViewDelegate:self];
    }
    return _webViewBridge;
}
#pragma mark==注册

- (void)registLocationFunction
{
//    //    - (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler {
//    //   后面的block参数是js要调用的Native实现   handlerName 是这个native实现的别名
//
    // js调我
    [self.webViewBridge registerHandler:@"jsDiaoOc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
        if (responseCallback) {
            // 反馈给JS
            responseCallback(@{@"userId": @"1345980"});
        }
    }];
    //调用js方法
    [self.webViewBridge callHandler:@"ocDiaoWo" data:@{@"B":@"刘德华"} responseCallback:^(id responseData) {
        NSLog(@"js给我的数据: %@", responseData);
    }];
    
    [self.webViewBridge callHandler:@"getUserInfos" data:@{@"name": @"HH"} responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
}

- (void)onOpenBlogArticle:(id)sender {
    // 调用打开本demo的博文
    [self.webViewBridge callHandler:@"openWebviewBridgeArticle" data:nil];
}

-(void)locationClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self onOpenBlogArticle:nil];
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
