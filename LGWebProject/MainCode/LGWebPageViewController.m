//
//  LGWebPageViewController.m
//  LGWebProject
//
//  Created by loghm on 2018/1/15.
//  Copyright © 2018年 loghm. All rights reserved.
//

#import "LGWebPageViewController.h"
#import "TZImagePickerController+ImagePicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "FSActionSheet.h"
#import "ActivityView.h"

@interface LGWebPageViewController ()<UIWebViewDelegate, SSZipArchiveDelegate, UMSocialShareMenuViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>  {
    NSString *_loctionJsonStr;
    UIImagePickerController *_imagePickerController;
    NSDictionary *_uploadDict;
    
}

@property (strong, nonatomic) UIWebView *webView;

@property (strong,nonatomic) ActivityView * activityView;

@end

@implementation LGWebPageViewController {
    BOOL _isHave;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [MobClick beginLogPageView:@"WebControl"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"WebControl"];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isHave = NO;
    
    [self setStatusBarColor:[UIColor whiteColor]];
    
    [self setupWebView];
    
    [self setNavBack];
    
    [self setNetworkStatue];
    
    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayReslut:) name:@"aliPayReslut" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayReslut:) name:@"wxpayReslut" object:nil];
    
    //下载自动更新
    [self autoUpdate];
    //[self requestWebView];
    
    //定位未开启提示
    [[LocationManager shareInstance] locationServicesStatus];
    
    
    //播放音频没声音
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    BOOL flag;
    
    NSError *setCategoryError = nil;
    
    flag = [audioSession setCategory:AVAudioSessionCategoryPlayback
            
            
            
                               error:&setCategoryError];
}


//网络监听
- (void)setNetworkStatue {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
    
}

/*
 * 自动更新
 */

- (void)autoUpdate {
    
    NSDictionary *versionDict = [NSDictionary dictionary];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Version.plist"];
    BOOL Exists = [fileManager fileExistsAtPath:filePatch];
    if(!Exists){
        [versionDict writeToFile:filePatch atomically:YES];
    }
#pragma mark-#再根据版本号判断，是否下载。第一次先保存一个空的版本号为空，直接走网络下载，然后保存当前下载完之后的版本号，再次运行app的时候，判断保存的版本号，跟接口给的版本号是否一致，一致的话，就不用下载，不一致，就下载新的。如下判断：
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    
    NSString *version = [usersDic objectForKey:@"htmlVersion"];
    
    NSString * url =  @"http://download.xmappservice.com/haiyi.update.json";
    [[NetworkManager shareInstance] requestNoHeadGetWithURL:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (responseObject) {
            
            if (!version) {
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Version.plist"];
                NSMutableDictionary *applist = [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
                NSString *name = [applist objectForKey:@"htmlVersion"];
                name = [responseObject objectForKey:@"version"];
                [applist setObject:name forKey:@"htmlVersion"];
                [applist writeToFile:path atomically:YES];
                
                //下载解压缩
                [self downloadFileWithfilePath:responseObject[@"download"]];
                
            } else {
                
                
                if ([version isEqualToString:[responseObject objectForKey:@"version"]]) {
                    
                    NSLog(@"不下载不解压");
                    [self loadWebView];
                    
                    
                } else {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"logs"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    UIAlertAction *confirmAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        //保存新html的版本号
                        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Version.plist"];
                        NSMutableDictionary *applist = [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
                        NSString *name = [applist objectForKey:@"htmlVersion"];
                        name = [responseObject objectForKey:@"version"];
                        [applist setObject:name forKey:@"htmlVersion"];
                        [applist writeToFile:path atomically:YES];
                        
                        //下载解压缩
                        [self downloadFileWithfilePath:responseObject[@"download"]];
                        
                        
                    }];
                    
                    [alertController addAction:cancelAc];
                    [alertController addAction:confirmAc];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                }
                
            }
            
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, NSString *errMessage) {
        
        [MBProgressHUD showMessage:errMessage toView:self.view];
        
    }];
    
    
}


- (void)downloadFileWithfilePath:(NSString *)filePath {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[DownLoadFileManager getInstance] downloadFileWithOption:nil withFileUrl:filePath fileName:@"file" fileCreated:[[NSDate date] timeIntervalSince1970] downloadSuccess:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        NSString *htmlFilePath = [filePath path];// 将NSURL转成NSString
        NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *zipedPath = [[documentArray lastObject] stringByAppendingPathComponent:@"Preferences"];
        if ([SSZipArchive unzipFileAtPath:htmlFilePath toDestination:zipedPath delegate:self]) {
            [self loadWebView];
        }
        
        
    } progress:^(NSProgress *downloadProgress) {
        
        //NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    }];
    
    
}

#pragma mark 解压
- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath{
    
    NSError *error;
    
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
        NSLog(@"success");
    }
    else{
        NSLog(@"%@",error);
    }
    
}

#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    NSLog(@"将要解压。");
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    
    NSLog(@"解压完成！");
    
}




// 设置导航栏返回按钮
- (void)setNavBack {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"nev_icon_cancel"] forState:0];
    [button addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(13, 7, 34, 34);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)onTap: (UIButton *)button {
    if ([self.webView canGoBack]) {//判断当前的H5页面是否可以返回
        //如果可以返回，则返回到上一个H5页面，并在左上角添加一个关闭按钮
        [self.webView goBack];
        
    } else {
        //如果不可以返回，则直接:
        
        //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:INDEX_URL]];
        //[self.webView loadRequest:request];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}


- (void)setStatusBarColor:(UIColor *)color {
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    statusBarView.backgroundColor=color;
    [self.view addSubview:statusBarView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - setup webView
- (void)setupWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-20)];
    [self.webView setup];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self registerUserAgent];
    
}

- (void)registerUserAgent {
    
    //获取App版本信息
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//App版本信息
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];//App名称
    
#pragma mark -- 添加userAgent
    NSString* secretAgent = [self.webView getUserAgent];
    
    NSString *newUagent = [NSString stringWithFormat:@"%@ Platform/IOS author/crawler vcode/%@ vname/%@",secretAgent,app_build,app_Name];
    
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newUagent, @"UserAgent", nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    NSLog(@"返回navigator.userAgent  1===========%@",secretAgent);
    NSLog(@"返回navigator.userAgent  2===========%@",newUagent);
    
}

- (void)requestWebView {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:INDEX_URL]];
    [self.webView loadRequest:request];
    
    
    //    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    //    NSURL* url = [NSURL fileURLWithPath:path];
    //    NSString *urlStr = [url absoluteString];
    //    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    //    NSURL * URL = [NSURL URLWithString:urlStr];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [self.webView loadRequest:request];
    
    
}

- (void)loadWebView {
    
    /*
     NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,YES);
     NSString *path = [[[documentPaths lastObject] stringByAppendingPathComponent:@"Preferences"]stringByAppendingPathComponent:@"index.html"];
     
     NSString * htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
     [self.webView loadHTMLString:htmlString baseURL:nil];
     */
    
    NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [[documentArray lastObject] stringByAppendingPathComponent:@"Preferences"];
    NSURL *url=[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/index.html",path]];
    NSString *urlStr = [url absoluteString];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSURL * URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
    
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    JSContext *context = [self.webView getjavaScriptContext];
    self.jsContext = context;
    self.jsContext[@"CrawlerJS"] = self;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //防止多次调用,后面去不掉指示器
    if (!_isHave) {
        _isHave = !_isHave;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_isHave) {
        _isHave = !_isHave;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //    NSString *currentURL = [webView getURLString];
    //    if ([[webView getURLHost] isEqualToString:@"haiyi.xmappservice.com"]) {
    //        self.navigationController.navigationBarHidden = YES;
    //    } else {
    //        self.navigationController.navigationBarHidden = NO;
    //        //获取html title设置导航栏 title
    //        self.title = [webView getPageTitle];
    //    }
    
    JSContext *context = [self.webView getjavaScriptContext];
    self.jsContext = context;
    self.jsContext[@"CrawlerJS"] = self;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    //禁用webView手势
    [self.webView webkitUserSelect];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView加载失败%@",error);
}


#pragma mark - 登录
//登录
- (NSString *)getToken {
    
    if ([userDef objectForKey:USER_INFO]) {
        return [self dictionaryToJson:[userDef objectForKey:USER_INFO]];
    } else {
        
        [self login];
        return @"";
        
    }
    
}

- (NSString *)getLoginData {
    
    if ([userDef objectForKey:USER_ACCOUNT]) {
        return [self dictionaryToJson:[userDef objectForKey:USER_ACCOUNT]];
    } else {
        
        [self login];
        return @"";
    }
    
}

- (NSString *)refreshToken {
//    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"该接口还未定义" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    return @"";
}

- (void)forgetWord {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        UpdatePasswordViewController *updatePassword = [[UpdatePasswordViewController alloc] init];
//        [self.navigationController pushViewController:updatePassword animated:YES];
        
    });
    
    
}

- (void)tocleanCache {
    
    NSString *catch = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *message = [NSString stringWithFormat:@"当前有%.2lfM缓存,是否清除?",[self folderSizeAtPath:catch]];
    
//    [UIAlertView showWithTitle:@"提示" message:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//
//            [self removeCache];
//            [self.view makeToast:@"清除缓存成功" duration:2 position:@"CSToastPositionCenter"];
//        }
//    }];
    
    
}

//通常用于删除缓存的时，计算缓存大小
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
//清除缓存
-(void)removeCache
{
    //===============清除缓存==============
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    for (NSString *p in files)
    {
        NSError *error;
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //清除UIWebView的缓存
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)login {
    
//    LoginViewController *login = [[LoginViewController alloc] init];
//    login.isRooterVC = NO;
//    NavViewController *loginNav = [[NavViewController alloc] initWithRootViewController:login];
//    [self presentViewController:loginNav animated:YES completion:nil];
    
}

- (void)getLocation:(NSString *)params {
    
    NSDictionary *dict = [self dictionaryWithJsonString:params];
    
    _loctionJsonStr = [LocationManager shareInstance].locationJsonString;
    
    JSValue *jsFunc = self.jsContext[dict[@"callback"]];
    [jsFunc callWithArguments:@[_loctionJsonStr]];
    
}

- (void)logout {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [userDef removeObjectForKey:USER_INFO];
        [userDef removeObjectForKey:USER_ACCOUNT];
        [userDef removeObjectForKey:@"userID"];
        [userDef removeObjectForKey:USER_ISLOGINED];
//        LoginViewController *login = [[LoginViewController alloc] init];
//        login.isRooterVC = NO;
//        NavViewController *loginNav = [[NavViewController alloc] initWithRootViewController:login];
//        [self presentViewController:loginNav animated:YES completion:nil];
        
        
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
    });
    
}


-(void) back {
    //判断 webView能不能返回,可以就返回,不可以就直接返回原生
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)exit {
    //退出App
    exit(0);
}


#pragma mark - Picker View

//地域选择
- (void)regionPicker:(NSString *)params {
    
    NSDictionary *paraDict = [self dictionaryWithJsonString:params];
    
    AddressPicker *addressPicker = [[AddressPicker alloc] init];
    
    if ([paraDict[@"current"] length] > 0) {
        addressPicker.sourceDict = [self dictionaryWithJsonString:paraDict[@"current"]];
    }
    
    [addressPicker setAddressBlock:^(AddressPicker *picker, NSString *province, NSString *city, NSString *area) {
        
        NSArray *dataArray = picker.pickerArray;
        NSInteger component1 = [picker.pickView selectedRowInComponent:0];
        NSInteger component2 = [picker.pickView selectedRowInComponent:1];
        NSInteger component3 = [picker.pickView selectedRowInComponent:2];
        
        NSString *code1 = dataArray[component1][@"code"];
        NSString *code2 = dataArray[component1][@"children"][component2][@"code"];
        NSString *code3 = dataArray[component1][@"children"][component2][@"children"][component3][@"code"];
        
        
        NSDictionary *addressDict = @{@"province":@{@"code":code1,
                                                    @"label":province},
                                      @"city":@{@"code":code2,
                                                @"label":city},
                                      @"district":@{@"code":code3,
                                                    @"label":area}};
        NSData *data = [NSJSONSerialization dataWithJSONObject:addressDict options:0 error:nil];
        NSString *address = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        JSValue *jsFunction = self.jsContext[paraDict[@"callback"]];
        [jsFunction callWithArguments:@[address]];
        
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [addressPicker show];
    });
    
}

//时间选择
- (void)datePicker:(NSString *)params {
    
    NSDictionary *paraDict = [self dictionaryWithJsonString:params];
    NSString *dateFormet = nil;
    if (paraDict[@"format"]) {
        dateFormet = paraDict[@"format"];
    } else {
        dateFormet = @"yyyy-MM-dd";
    }
    
    DatePicker *datePicker = [DatePicker createDatePicker];
    datePicker.dateBlock = ^(NSDate *date) {
        
        NSDateFormatter *DATEFormatter = [[NSDateFormatter alloc] init];
        [DATEFormatter setDateFormat:dateFormet];
        NSString *dateStr = [DATEFormatter stringFromDate:date];
        
        JSValue *jsFunc = self.jsContext[paraDict[@"callback"]];
        [jsFunc callWithArguments:@[dateStr]];
        
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [datePicker show];
    });
    
}

//通用Picker
- (void)picker:(NSString *)jsonString {
    
    NSDictionary * paramDict = [self arrayWithJsonString:jsonString];
    NSArray *dataAry = paramDict[@"data"];
    
    CommonPicker *commonPicker = [CommonPicker createCommonPicker:dataAry];
    commonPicker.confirmBlock = ^(NSString *content) {
        
        NSMutableArray * resultAry = [NSMutableArray array];
        
        NSArray*contentAry = [content componentsSeparatedByString:@" "];
        
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        [contentAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSInteger selectRow = [commonPicker.pickerView selectedRowInComponent:idx];
            NSString *currentName = [dataAry[idx] objectAtIndex:selectRow][@"name"];
            if ([currentName isEqualToString:obj]) {
                [resultAry addObject:[dataAry[idx] objectAtIndex:selectRow]];
            }
            
            
        }];
        
        NSString *resultStr = [self arrayToJson:resultAry];
        
        JSValue *jsFunc = self.jsContext[paramDict[@"callback"]];
        [jsFunc callWithArguments:@[resultStr]];
        
    };
    [commonPicker show];
    
}

- (void)linkagePicker:(NSString *)jsonString {
    
    NSDictionary *paramDict = [self dictionaryWithJsonString:jsonString];
    NSArray *dataAry = paramDict[@"data"];
    
    LinkagePicker *linkagePicker = [LinkagePicker createLinkagePicker:dataAry];
    linkagePicker.confirmBlock = ^(NSString *content, NSArray *resultAry) {
        
        NSString *resultStr = [self arrayToJson:resultAry];
        
        JSValue *jsFunc = self.jsContext[paramDict[@"callback"]];
        [jsFunc callWithArguments:@[resultStr]];
        
    };
    
    [linkagePicker show];
    
}

#pragma mark -- 调起支付
- (void)choosePay:(NSString *)payInfo {
    
    NSDictionary *payDict = [self dictionaryWithJsonString:payInfo];
    
    FSActionSheet *sheet = [[FSActionSheet alloc] initWithTitle:@"选择支付" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"支付宝",@"微信"]];
    sheet.selectedIndex = ^(FSActionSheet *actionSheet, NSInteger selectedIndex) {
        
        if (selectedIndex == 0) {
            
            NSString *url = [payDict[@"url"] stringByReplacingOccurrencesOfString:@"{type}" withString:@"alipay"];
            
            NSString *utf = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",utf);
            [[NetworkManager shareInstance] requestGetWithURL:utf parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSString *orderString = responseObject[@"order_string"];
                NSLog(@"=========%@",responseObject);
                NSString *appScheme = @"com.binnvshe.demo.alipay";
                
//                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                    self.view.userInteractionEnabled = YES;
//
//                    NSLog(@"支付的结果:*********reslut = %@",resultDic);
//                    NSString *result = [NSString stringWithFormat:@"%@", resultDic[@"resultStatus"]];
//                    if ([result isEqualToString:@"9000"]) {
//
//                        //成功时返回JS的参数
//                        JSValue *jsParamFunc = self.jsContext[@"onPaySuccess"];
//                        [jsParamFunc callWithArguments:@[@"0"]];
//
//                        return;
//                    }else {
//
//                        JSValue *jsParamFunc = self.jsContext[@"onPaySuccess"];
//                        [jsParamFunc callWithArguments:@[@"1"]];
//
//                        //支付失败 返回
//                        NSLog(@"zhifushibai");
//                    }
//                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error, NSString *errMessage) {
                
                [MBProgressHUD showMessage:errMessage toView:self.view];
                
            }];
            
        } else if (selectedIndex == 1) {
            
            
//            if (![WXApi isWXAppInstalled]){  // 是否安装了微信
//                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有安装微信" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alter show];
//            } else if (![WXApi isWXAppSupportApi]){ // 是否支持微信支付
//
//                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不支持微信支付" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alter show];
//
//            }else{  //已安装微信, 进行支付
                //[self WXPay];
                //NSDictionary *primary = @{@"Authorization":[userDef objectForKey:USERID]};
//                NSString *url = [payDict[@"url"] stringByReplacingOccurrencesOfString:@"{type}" withString:@"wxpay"];
//                NSString *utf = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//                [[NetworkManager shareInstance] requestNoHeadGetWithURL:utf parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//                    NSLog(@"请求回来的数据 = %@",responseObject);
//                    //需要创建这个支付对象
//                    PayReq *req= [[PayReq alloc]init];
//
//                    req.partnerId = [NSString stringWithFormat:@"%@", responseObject[@"partnerid"]];
//                    req.prepayId = [NSString stringWithFormat:@"%@", responseObject[@"prepayid"]];
//                    req.package = [NSString stringWithFormat:@"%@", responseObject[@"package"]];
//                    req.nonceStr= [NSString stringWithFormat:@"%@", responseObject[@"noncestr"]];
//                    req.timeStamp = [[NSString stringWithFormat:@"%@", responseObject[@"timestamp"]] intValue];
//                    req.sign = [NSString stringWithFormat:@"%@", responseObject[@"sign"]];
//
//                    BOOL result = [WXApi sendReq:req];
//                    if (result) {
//                        //成功时返回JS的参数
//                        JSValue *jsParamFunc = self.jsContext[@"onPaySuccess"];
//                        [jsParamFunc callWithArguments:@[@"0"]];
//                    } else {
//
//                        //失败时返回JS的参数
//                        JSValue *jsParamFunc = self.jsContext[@"onPaySuccess"];
//                        [jsParamFunc callWithArguments:@[@"1"]];
//
//                    }
//
//                } failure:^(NSURLSessionDataTask *task, NSError *error, NSString *errMessage) {
//
//                    [MBProgressHUD showMessage:errMessage toView:self.view];
//
//                }];
                
//            }CommonPicker
        }
        
        
    };
    [sheet show];
    
    
    
    
}


#pragma mark - 支付
- (void)pay:(NSString *)payInfo {
    
    
    NSDictionary *payDict = [self dictionaryWithJsonString:payInfo];
    if ([payDict[@"type"] isEqualToString:@"alipay"]) {
        
        NSString *appScheme = @"com.binnvshe.demo.alipay";
        
        NSDictionary *orderInfoDict = [self dictionaryWithJsonString:payDict[@"params"]];
        NSLog(@"%@",orderInfoDict[@"order_string"]);
//        [[AlipaySDK defaultService] payOrder:orderInfoDict[@"order_string"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            self.view.userInteractionEnabled = YES;
//
//            NSLog(@"支付的结果:*********reslut = %@",resultDic);
//            NSString *result = [NSString stringWithFormat:@"%@", resultDic[@"resultStatus"]];
//            if ([result isEqualToString:@"9000"]) {
//
//                JSValue *jsFunc = self.jsContext[payDict[@"callback"]];
//                [jsFunc callWithArguments:@[@"0"]];
//
//            }else {
//                //支付失败 返回
//                JSValue *jsFunc = self.jsContext[payDict[@"callback"]];
//                [jsFunc callWithArguments:@[@"1"]];
//
//            }
//        }];
        
        __weak typeof(self) weakSelf = self;
//        AppDelegate *myAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//        myAppDelegate.alipayReqResult = ^(NSString *result) {
//
//            if ([result isEqualToString:@"9000"]) {
//                JSValue *jsFunc = weakSelf.jsContext[payDict[@"callback"]];
//                JSValue *result = [jsFunc callWithArguments:@[@"0"]];
//                NSLog(@"%@",result);
//            } else {
//                JSValue *jsFunc = weakSelf.jsContext[payDict[@"callback"]];
//                JSValue *result = [jsFunc callWithArguments:@[@"1"]];
//                NSLog(@"%@",result);
//            }
//
//        };
//
        
    } else if ([payDict[@"type"] isEqualToString:@"wxpay"]) {
        
//        NSDictionary *resultDict = [self dictionaryWithJsonString:payDict[@"params"]];
//
//        PayReq *request = [[PayReq alloc] init] ;
//        request.partnerId = [NSString stringWithFormat:@"%@", resultDict[@"partnerid"]];
//        request.prepayId = [NSString stringWithFormat:@"%@", resultDict[@"prepayid"]];
//        request.package = [NSString stringWithFormat:@"%@", resultDict[@"package"]];
//        request.nonceStr= [NSString stringWithFormat:@"%@", resultDict[@"noncestr"]];
//        request.timeStamp = [[NSString stringWithFormat:@"%@", resultDict[@"timestamp"]] intValue];
//        request.sign = [NSString stringWithFormat:@"%@", resultDict[@"sign"]];
//
//        [WXApi sendReq:request];
//
//        AppDelegate *myAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        __weak typeof(self) weakSelf = self;
//        myAppDelegate.wxReqResult = ^(NSInteger result) {
//
//            if (result == 0) {
//                JSValue *jsFunc = weakSelf.jsContext[payDict[@"callback"]];
//                [jsFunc callWithArguments:@[@"0"]];
//            } else {
//                JSValue *jsFunc = weakSelf.jsContext[payDict[@"callback"]];
//                [jsFunc callWithArguments:@[@"1"]];
//            }
//
//        };
        
        
        
    }
    
}




#pragma mark --支付回调
-(void)aliPayReslut:(NSNotification *)notFication
{
    NSLog(@"返回的支付状态%@",notFication.userInfo[@"resultStatus"]);
    if ([notFication.userInfo[@"resultStatus"] isEqualToString:@"9000"]) {
        
        //成功时返回JS的参数
        JSValue *jsParamFunc = self.jsContext[@"onPaySuccess"];
        [jsParamFunc callWithArguments:@[@"0"]];
        
        return;
    }else {
        //支付失败 返回
        JSValue *jsParamFunc = self.jsContext[@"onPaySuccess"];
        [jsParamFunc callWithArguments:@[@"1"]];
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aliPayReslut" object:nil];
}

-(void)wxpayReslut:(NSNotification *)notFication{
    NSLog(@"%@",notFication.userInfo);
    if ([notFication.userInfo[@"code"] isEqualToString:@"0"]) {
        
        //成功时返回JS的参数
        JSValue *jsParamFunc = self.jsContext[@"onPayResult"];
        [jsParamFunc callWithArguments:@[@"0"]];
        
        return;
    }else {
        //支付失败 返回
        
        JSValue *jsParamFunc = self.jsContext[@"onPayResult"];
        [jsParamFunc callWithArguments:@[@"1"]];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aliPayReslut" object:nil];
    
}




#pragma mark -- 分享
//分享 提供UI

- (void)chooseShare:(NSString *)params {
    
    NSDictionary *paramsDict = [self dictionaryWithJsonString:params];
    //    NSDictionary *paramsDict = @{@"title":@"lalal",
    //                                 @"desc":@"wuwwuwuwu",
    //                                 @"imgUrl":@"http://www.baidu.com/ceshi.mp4",
    //                                 @"link":@"http://www.baidu.com",
    //                                 @"callback":@"shareSuccess"};
    // 创建分享视图
    if (!self.activityView) {
        
        self.activityView = [[ActivityView alloc] initWithTitle:@"      分享到" referView:[UIApplication sharedApplication].keyWindow];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 6;
        
        ButtonView *wechatBV = [[ButtonView alloc]initWithText:@"好友" image:[UIImage imageNamed:@"share_platform_wechat"] handler:^(ButtonView *buttonView){
            
            [self requestShareParams:paramsDict platformType:UMSocialPlatformType_WechatSession];
            
        }];
        [self.activityView addButtonView:wechatBV];
        
        ButtonView *wechattlBV = [[ButtonView alloc]initWithText:@"朋友圈" image:[UIImage imageNamed:@"share_platform_wechattimeline"] handler:^(ButtonView *buttonView){
            
            [self requestShareParams:paramsDict platformType:UMSocialPlatformType_WechatTimeLine];
            
        }];
        [self.activityView addButtonView:wechattlBV];
        
        
        //        ButtonView *qqBV = [[ButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"share_platform_QQ"] handler:^(ButtonView *buttonView){
        //
        //            [self requestShareParams:paramsDict platformType:UMSocialPlatformType_QQ];
        //
        //
        //        }];
        //        [self.activityView addButtonView:qqBV];
        //
        //
        //        ButtonView *qqZoneBV = [[ButtonView alloc]initWithText:@"QQ空间" image:[UIImage imageNamed:@"share_platform_QQZone"] handler:^(ButtonView *buttonView){
        //
        //            [self requestShareParams:paramsDict platformType:UMSocialPlatformType_Qzone];
        //
        //        }];
        //        [self.activityView addButtonView:qqZoneBV];
        //
        //
        //        ButtonView *sinaBV = [[ButtonView alloc]initWithText:@"微博" image:[UIImage imageNamed:@"share_platform_wechattimeline"] handler:^(ButtonView *buttonView){
        //
        //            [self requestShareParams:paramsDict platformType:UMSocialPlatformType_Sina];
        //
        //        }];
        //        [self.activityView addButtonView:sinaBV];
        
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.activityView show];
        
    });
    
    
    /*
     NSDictionary *paramsDict = [self dictionaryWithJsonString:params];
     
     [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Sina)]];
     
     [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
     [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
     
     [UMSocialUIManager setShareMenuViewDelegate:self];
     
     //显示分享面板
     [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
     // 根据获取的platformType确定所选平台进行下一步操作
     
     //创建分享消息对象
     UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
     
     //创建网页内容对象
     NSString* thumbURL = paramsDict[@"imgUrl"];
     UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:paramsDict[@"title"] descr:paramsDict[@"desc"] thumImage:thumbURL];
     //设置网页地址
     shareObject.webpageUrl = paramsDict[@"link"];
     
     //分享消息对象设置分享内容对象
     messageObject.shareObject = shareObject;
     
     //调用分享接口
     [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
     if (error) {
     UMSocialLogInfo(@"************Share fail with error %@*********",error);
     JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
     [jsFunc callWithArguments:@[@"1"]];
     
     }else{
     
     JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
     [jsFunc callWithArguments:@[@"0"]];
     
     if ([data isKindOfClass:[UMSocialShareResponse class]]) {
     UMSocialShareResponse *resp = data;
     //分享结果消息
     UMSocialLogInfo(@"response message is %@",resp.message);
     //第三方原始返回的数据
     UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
     
     }else{
     UMSocialLogInfo(@"response data is %@",data);
     }
     }
     
     }];
     
     }];
     */
    
}

//分享,不提供UI
- (void)share:(NSString *)params {
    
    NSDictionary *paramsDict = [self dictionaryWithJsonString:params];
    
    UMSocialPlatformType platformType;
    
    NSString *platform = paramsDict[@"platform"];
    
    if ([platform isEqualToString:@"Wechat"]) {
        //微信好友
        platformType = UMSocialPlatformType_WechatSession;
    } else if ([platform isEqualToString:@"WechatMoments"]) {
        //微信朋友圈
        platformType = UMSocialPlatformType_WechatTimeLine;
    } else if ([platform isEqualToString:@"QQ"]) {
        //QQ
        platformType = UMSocialPlatformType_QQ;
    } else if ([platform isEqualToString:@"QZone"]) {
        //QZone(QQ空间)
        platformType = UMSocialPlatformType_Qzone;
    } else if ([platform isEqualToString:@"SinaWeibo"]) {
        //新浪微博
        platformType = UMSocialPlatformType_Sina;
    } else {
        platformType = UMSocialPlatformType_UnKnown;
    }
    
    //请求分享
    [self requestShareParams:paramsDict platformType:platformType];
    
    
}

- (void)requestShareParams:(NSDictionary *)paramsDict platformType:(UMSocialPlatformType)platform {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = paramsDict[@"imgUrl"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:paramsDict[@"title"] descr:paramsDict[@"desc"] thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = paramsDict[@"link"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
            [jsFunc callWithArguments:@[@"1"]];
        }else{
            
            JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
            [jsFunc callWithArguments:@[@"0"]];
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];
    
}

#pragma mark - 上传文件
- (void)chooseUpload:(NSString *)params {
    
    NSDictionary *paramsDict = [self dictionaryWithJsonString:params];
    
    TZImagePickerController *imagePicker = [TZImagePickerController shareInstall];
    imagePicker.maxImagesCount = [paramsDict[@"limit"] integerValue];
    
    
    if ([paramsDict[@"type"] isEqualToString:@"image"]) {
        
        
        
        __weak typeof(self) weakSelf = self;
        FSActionSheet *fsAS = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"相册"]];
        [fsAS show];
        
        fsAS.selectedIndex = ^(FSActionSheet *actionSheet, NSInteger selectedIndex) {
            
            if (selectedIndex == 0) {
                //拍照
                _uploadDict = paramsDict;
                _imagePickerController = [[UIImagePickerController alloc] init];
                _imagePickerController.delegate = self;
                _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                _imagePickerController.allowsEditing = YES;
                [self openCamara];
                
            } else {
                //相册
                
                imagePicker.allowPickingImage = YES;
                imagePicker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    
                    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                    
                    NSString *url = paramsDict[@"uploader"];
                    
                    [FileUploader upLoadFile:url parameters:nil images:photos name:@"image" response:JSON progress:^(NSProgress *progress) {
                        
                        
                    } success:^(NSURLSessionDataTask *task, id responseObject) {
                        
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        if (responseObject) {
                            
                            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                            NSString *filePath = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            JSValue *jsFunc = weakSelf.jsContext[paramsDict[@"callback"]];
                            [jsFunc callWithArguments:@[filePath]];
                        }
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                        NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
                        NSDictionary *errDict =[NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
                        
                        NSString *filePath = @"[]";
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        JSValue *jsFunc = weakSelf.jsContext[paramsDict[@"callback"]];
                        [jsFunc callWithArguments:@[filePath]];
                        
                    }];
                    
                };
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf presentViewController:imagePicker animated:YES completion:nil];
                });
                
            }
            
            
        };
        
        
    } else if ([paramsDict[@"type"] isEqualToString:@"audio"]) {
        
        
        AudioViewController *audio = [[AudioViewController alloc] init];
        audio.getFilepath = ^(NSString *filePath) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
            NSString *url = paramsDict[@"uploader"];
            NSString *fileName = [FileUploader getDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] With:@"yyyyMMddhhMMss"];
            fileName = [fileName stringByAppendingString:@".mp3"];
            [FileUploader upLoadFile:url parameters:nil fileData:data name:@"files" fileName:fileName mimeType:@"application/octet-stream" response:JSON progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"%@",responseObject);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (responseObject) {
                    NSString *filePath = responseObject[@"url"];
                    [SYAudioFile SYAudioDeleteFileWithFilePath:filePath];
                    JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
                    [jsFunc callWithArguments:@[filePath]];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@",error);
                NSString *filePath = @"";
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
                [jsFunc callWithArguments:@[filePath]];
            }];
            
            
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:audio animated:YES completion:nil];
            
        });
        
        
    } else if ([paramsDict[@"type"] isEqualToString:@"video"]) {
        if ([paramsDict[@"multi"] intValue] == 1) {
            imagePicker.allowPickingMultipleVideo = YES;
        }
        imagePicker.allowPickingVideo = YES;
        imagePicker.didFinishPickingVideoHandle = ^(UIImage *coverImage, id asset) {
            
            if ([asset isKindOfClass:[PHAsset class]]) {
                
                PHAsset *phAsset = asset;
                NSArray *assetResources = [PHAssetResource assetResourcesForAsset:phAsset];
                PHAssetResource *resource;
                
                for (PHAssetResource *assetRes in assetResources) {
                    if (assetRes.type == PHAssetResourceTypePairedVideo ||
                        assetRes.type == PHAssetResourceTypeVideo) {
                        resource = assetRes;
                    }
                }
                NSString *fileName = @"tempAssetVideo.mov";
                if (resource.originalFilename) {
                    fileName = resource.originalFilename;
                }
                
                if (phAsset.mediaType == PHAssetMediaTypeVideo || phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                    options.version = PHImageRequestOptionsVersionCurrent;
                    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                    
                    NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
                    [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
                    [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE] options:nil completionHandler:^(NSError * _Nullable error) {
                        if (error) {
                            
                        } else {
                            
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            
                            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
                            
                            NSString *url = paramsDict[@"uploader"];
                            
                            NSString *fileName = [FileUploader getDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceNow]] With:@"yyyyMMddHHMMss"];
                            fileName = [fileName stringByAppendingString:@".mp4"];
                            [FileUploader upLoadFile:url parameters:nil fileData:data name:@"files" fileName:fileName mimeType:@"video/quicktime" response:JSON progress:^(NSProgress *progress) {
                                
                            } success:^(NSURLSessionDataTask *task, id responseObject) {
                                NSLog(@"%@",responseObject);
                                if (responseObject) {
                                    NSString *filePath = responseObject[@"url"];
                                    
                                    JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
                                    [jsFunc callWithArguments:@[filePath]];
                                    
                                    //NSString *getURL=@"geturl"; //准备执行的js代码
                                    //[self.jsContext evaluateScript:getURL];//通过oc方法调用js的方法
                                }
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                NSLog(@"%@",error);
                                NSString *filePath = @"";
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                
                                JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
                                [jsFunc callWithArguments:@[filePath]];
                                
                            }];
                        }
                        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                    }];
                    
                    
                    
                } else {
                    
                    
                    
                }
                
                
            } else if ([asset isKindOfClass:[ALAsset class]]) {
                
                ALAsset *alAsset = (ALAsset *)asset;
                ALAssetRepresentation *defaultRepresentation = [alAsset defaultRepresentation];
                NSString *uti = [defaultRepresentation UTI];
                NSURL *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                NSData *data = [NSData dataWithContentsOfURL:videoURL];
                
                NSString *url = paramsDict[@"uploader"];
                
                NSString *fileName = [FileUploader getDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] With:@"yyyyMMddhhMMss"];
                fileName = [fileName stringByAppendingString:@".mp4"];
                [FileUploader upLoadFile:url parameters:nil fileData:data name:@"files" fileName:fileName mimeType:@"video/quicktime" response:JSON progress:^(NSProgress *progress) {
                    
                } success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSLog(@"%@",responseObject);
                    if (responseObject) {
                        NSString *filePath = responseObject[@"url"];
                        JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
                        [jsFunc callWithArguments:@[filePath]];
                        
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"%@",error);
                    NSString *filePath = @"";
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    JSValue *jsFunc = self.jsContext[paramsDict[@"callback"]];
                    [jsFunc callWithArguments:@[filePath]];
                    
                }];
                
                
            }
            
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePicker animated:YES completion:nil];
        });
    }
    
}

#pragma mark 从摄像头获取图片或视频
- (void)openCamara
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    //_imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    //_imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];//@[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    //_imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    //_imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
        //保存图片至相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //上传图片
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *url = _uploadDict[@"uploader"];
        
        [FileUploader upLoadFile:url parameters:nil images:@[image] name:@"image" response:JSON progress:^(NSProgress *progress) {
            
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (responseObject) {
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                NSString *filePath = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                JSValue *jsFunc = self.jsContext[_uploadDict[@"callback"]];
                [jsFunc callWithArguments:@[filePath]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSString *filePath = @"[]";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            JSValue *jsFunc = self.jsContext[_uploadDict[@"callback"]];
            [jsFunc callWithArguments:@[filePath]];
            
        }];
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //播放视频
        //        _moviePlayer.contentURL = url;
        //        [_moviePlayer play];
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //视频上传
        //        [self uploadVideoWithData:videoData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}



- (void)enterFastLook {
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
//        notificationVC.isRefreshMain = ^{
//            [self loadWebView];
//        };
//        [self.navigationController pushViewController:notificationVC animated:YES];
    });
}

#pragma mark - 私有方法
//json格式字符串转字典：

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}


//字典转json格式字符串：

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//json格式字符串转数组：
- (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSArray *ary = [NSJSONSerialization JSONObjectWithData:jsonData
                    
                                                   options:NSJSONReadingMutableContainers
                    
                                                     error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return ary;
    
}


//数组转json格式字符串：

- (NSString*)arrayToJson:(NSArray *)ary

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ary options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

//不需要改变父窗口则不需要重写此协议
- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return defaultSuperView;
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
