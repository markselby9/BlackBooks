//
//  BBAboutmeViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/5.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "BBAboutmeViewController.h"

@interface BBAboutmeViewController ()<UIWebViewDelegate>{
    BOOL isFirstLoadWeb;
}

@property (nonatomic) UIWebView *webview;

@end

@implementation BBAboutmeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webview = [[UIWebView alloc] initWithFrame:[self.view bounds]];
    _webview.backgroundColor = [UIColor clearColor];
    _webview.scalesPageToFit =YES;
    _webview.delegate =self;
    [self.view addSubview:_webview];
    
    NSURL *url =[[NSURL alloc] initWithString:@"http://markselby9.github.io/blackbooks/about.html"];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
    [_webview loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //程序会一直调用该方法，所以判断若是第一次加载后就使用我们自己定义的js，此后不在调用JS,否则会出现网页抖动现象
    if (!isFirstLoadWeb) {
        isFirstLoadWeb = YES;
    }else
        return;
    //给webview添加一段自定义的javascript
    
    [webView stringByEvaluatingJavaScriptFromString:@"alert(\"Thanks for visiting!\");"];
    
    //开始调用自定义的javascript
//    [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
