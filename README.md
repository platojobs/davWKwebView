# davWKwebView
WKWebView与JS交互  
 
+（WKWebView第一种方法）

### JS调用OC

```objc

//这个类主要用来做native与JavaScript的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //注册一个name为jsToOcNoPrams的js方法，设置处理接收JS方法的代理
        [wkUController addScriptMessageHandler:self  name:@"jsToOcNoPrams"];
        [wkUController addScriptMessageHandler:self  name:@"jsToOcWithPrams"];
        config.userContentController = wkUController;

注意：遵守WKScriptMessageHandler协议，代理是由WKUserContentControl设置
 //通过接收JS传出消息的name进行捕捉的回调方法  js调OC
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
}

```



### OC调用JS

> `[webView evaluateJavaScript:@"`callJS('这是iOS消息')`" completionHandler:^(id _Nullable item, NSError * _Nullable error) {

        NSLog(@"%@",item);

    }];`



```objc

//OC调用JS  changeColor()是JS方法名，completionHandler是异步回调block
    NSString *jsString = [NSString stringWithFormat:@"changeColor('%@')", @"Js参数"];
    [_webView evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"改变HTML的背景色");
    }];
    
    //改变字体大小 调用原生JS方法
    NSString *jsFont = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", arc4random()%99 + 100];
    [_webView evaluateJavaScript:jsFont completionHandler:nil];


```

+ WKWebViewJavascriptBridge  （第二种方法）

```objc
//oc调用js代码
[_webViewBridge registerHandler:@"ocDiaowo" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 获取位置信息
        
        NSString *location = @"广东省深圳市南山区学府路XXXX号";
        // 将结果返回给js
        responseCallback(location);
    }];



```

