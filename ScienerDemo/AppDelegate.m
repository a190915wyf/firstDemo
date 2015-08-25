//
//  AppDelegate.m
//  ScienerDemo
//
//  Created by 谢元潮 on 14-10-29.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#import "AppDelegate.h"
#import "Tab0ViewController.h"
#import "DBHelper.h"
#import "Define.h"
#import "RequestService.h"
#import "ProgressHUD.h"
#import "XYCUtils.h"
#import "KeyBoardPsEditViewController.h"
#import "KeyboardPsManageViewController.h"

@interface AppDelegate ()
{

    
    
    
    
    Tab0ViewController * root;
    
    UIAlertView * init900PsAlert;
}
@end

BOOL isInitPsPool = FALSE;//初始化900个密码

@implementation AppDelegate

@synthesize s;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //初始化科技侠
    s = [[Sciener alloc]initWithAppId:kScienerAppkey appSecret:kScienerAppSecret redirectUri:kScienerRedirectUri delegate:self];
    [s setupBlueTooth];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    root = [[Tab0ViewController alloc]initWithNibName:@"Tab0ViewController" bundle:nil];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;
    
    //搜索附近蓝牙
    [s scan];
    
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if (s) {
        [s stopScan];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    [s HandleOpenURL:url];
    
    return YES;
    
    
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    
    NSLog(@"handle open url");
    
    return YES;
}



-(void)showAlertTitle:(NSString*)title msg:(NSString*)msg
{
    
    if(alertView&&!alertView.isHidden){
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        
        alertView = Nil;
        
    }
    
    alertView = [[UIAlertView alloc]initWithTitle:title
                                          message:msg
                                         delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles: nil];
    
    [alertView show];
    
}


-(void)cancelAlert
{
    
    if(alertView!=nil&&!alertView.isHidden){
        
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        
        alertView = Nil;
        
    }
    
}



//sciener delegate

//指令功能相关回调


-(void)scienerError:(ScienerError)error
{
    
    [[[UIAlertView alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"scienerError:%i",error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    
}


-(void)gotLockVersion:(NSString*)versionStr;
{

    NSLog(@"version:%@",versionStr);
}
-(void)addAdminSuccess_password:(NSString*)password key:(NSString*)key aesKey:(NSData*)aesKeyData version:(NSString*)versionStr mac:(NSString*)mac
{
    
    
}

-(void)setUserKeyBoardPasswordSuccess
{

    if ([KeyBoardPsEditViewController sharedInstance]) {
        
        [[KeyBoardPsEditViewController sharedInstance] addNewPsSuccess:YES errorCode:0];
    }

}

-(void)clearUserKeyBoardPasswordSuccess
{
    
    [ProgressHUD dismiss];
    [[[UIAlertView alloc]initWithTitle:@"键盘密码已清空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    
}

-(void)deleteUserKeyBoardPasswordSuccess
{

    [[KeyboardPsManageViewController sharedInstance].navigationController popViewControllerAnimated:YES];
    
    [ProgressHUD dismiss];
    [[[UIAlertView alloc]initWithTitle:@"键盘密码已删除成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    
}

-(void)setkeyboardPsFinish:(NSArray*)psArray
{
    
    NSLog(@"初始化完成");
    NSString * lockName = currentKey.lockName;
    
    for (int i = 0 ; i < psArray.count; i ++) {
        
        if (i<300) {
            
            [[DBHelper sharedInstance]saveTimePsWithlockName:lockName content:[psArray objectAtIndex:i] group:TIME_PS_GROUP_DAY_1D index:i];
            
        }else if(i < 450){
            
            [[DBHelper sharedInstance]saveTimePsWithlockName:lockName content:[psArray objectAtIndex:i] group:TIME_PS_GROUP_DAY_2D index:i-300];
            
        }else if(i < 550){
            
            [[DBHelper sharedInstance]saveTimePsWithlockName:lockName content:[psArray objectAtIndex:i] group:TIME_PS_GROUP_DAY_3D index:i-450];
            
        }else if(i < 650){
            
            [[DBHelper sharedInstance]saveTimePsWithlockName:lockName content:[psArray objectAtIndex:i] group:TIME_PS_GROUP_DAY_4D index:i-550];
            
        }else if(i < 700){
            
            [[DBHelper sharedInstance]saveTimePsWithlockName:lockName content:[psArray objectAtIndex:i] group:TIME_PS_GROUP_DAY_5D index:i-650];
            
        }else if(i < 750){
            
            [[DBHelper sharedInstance]saveTimePsWithlockName:lockName content:[psArray objectAtIndex:i] group:TIME_PS_GROUP_DAY_6D index:i-700];
            
        }else if(i < 800){
            
            [[DBHelper sharedInstance]saveTimePsWithlockName:lockName content:[psArray objectAtIndex:i] group:TIME_PS_GROUP_DAY_7D index:i-750];
            
        }else if(i < 900){
            
            [[DBHelper sharedInstance]saveTimePsWithlockName:lockName content:[psArray objectAtIndex:i] group:TIME_PS_GROUP_DAY_10M index:i-800];
            
        }
    }
}

-(void)setKeyboardPsSuccess:(float)progress
{
    
    NSLog(@"progress:%f",progress);
    
    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        if (init900PsAlert) {
            
            init900PsAlert.title = [NSString stringWithFormat:@"已完成：%f",progress];
            if (progress == 1.0f) {
                
                [init900PsAlert dismissWithClickedButtonIndex:0 animated:YES];
                
                init900PsAlert = [[UIAlertView alloc]initWithTitle:@"初始化完成" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [init900PsAlert show];
                
            }
            
        }else{
        
            init900PsAlert = [[UIAlertView alloc]initWithTitle:@"开始初始化" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [init900PsAlert show];
            
        }
        
    });
}

-(void)clearLockSuccess
{

}

-(void)renameLockSuccess
{

}

-(void)getKeyboardPs_type:(KeyboardPsType)type password:(NSString*)password times:(int)times startDate:(NSDate*)startDate endDate:(NSDate*)endDate isLast:(BOOL)isLast
{

    
    if ([KeyboardPsManageViewController sharedInstance]) {
        
        [[KeyboardPsManageViewController sharedInstance] getKeyPassword:type password:password times:times startDate:startDate endDate:endDate isLast:isLast];
    }
    
}

-(void)getPower:(float)power
{

}

-(void)calibationTimeSuccess
{
    
    NSLog(@"校准时间成功");
    
    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        [self cancelAlert];
        
    });
    
}

-(void)unlockSuccess
{
    
    NSLog(@"开门成功");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(queue, ^(void){
        
        __block int ret;
        
        dispatch_sync(queue, ^(void){
            
            AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            ret = [RequestService uploadUnlockRecord_success:YES roomID:currentKey.roomid clientid:kScienerAppkey accesstoken:delegate.s.accessToken];
            
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            
            NSLog(@"ret:%i",ret);
            
        });
        
    });
    
}

-(void)setAdminKeyboardPasswordSuccess
{
    
    NSLog(@"设置管理员密码成功");
    
    currentKey.adminKeyboardPs = currentKey.adminKeyboardPsTmp;
    currentKey.adminKeyboardPsTmp = @"";
    
    [[DBHelper sharedInstance]update];
    
    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alertTMP = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"设置管理员键盘密码成功。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertTMP show];
        
    });
    
}

-(void)setAdminDeleteKeyboardPasswordSuccess
{
    
    NSLog(@"设置管理员删除密码成功");
    
    currentKey.deletePs = currentKey.deletePsTmp;
    currentKey.deletePsTmp = @"";
    
    [[DBHelper sharedInstance]update];
    
    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alertTMP = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"设置管理员删除密码成功。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertTMP show];
        
        
    });
    
}


//授权回调
-(void)scienerDidLogin:(NSString*)errcode
{
    
    NSLog(@"scienerDidLogin:%@",errcode);
    
    if (errcode == nil || errcode.intValue == 0) {
        
        NSLog(@"token:%@,openid:%@,expiresIn:%@",s.accessToken,s.openID,s.expiresIn);
    
        if (root) {
        
            [root.customTableView reloadData];
        
        }
        
    }
    
}

//蓝牙搜索，连接相关回调
-(void)peripheralFound:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary*)advertisementData
{
    
    Key * dbKey = nil;
    
    NSLog(@"搜索到蓝牙:%@,lockname:%@",mac,lockName);
    
//    NSArray * array = [[DBHelper sharedInstance]fetchKeys];
//    for (Key* key in array) {
//        
//        NSLog(@"key:%@",key.lockmac);
//        
//    }
    if (mac && mac.length>0) {
        
        dbKey = [[DBHelper sharedInstance]fetchKeyWithLockMac:mac];
    }else{
        
        dbKey = [[DBHelper sharedInstance]fetchKeyWithLockName:lockName];
    }
    
    if (dbKey!=nil) {
        
        NSLog(@"有对应的 lockname:%@,lockmac:%@",dbKey.lockName,dbKey.lockmac);
        currentKey = dbKey;
        [s connect:peripheral];
        
    }
    
}

-(void)setConnect:(CBPeripheral *)peripheral lockName:(NSString*)lockName
{
    
    NSLog(@"连接上蓝牙:%@",peripheral.name);
    
    currentKey = [[DBHelper sharedInstance]fetchKeyWithLockName:lockName];
    
    if (!currentKey) {
        
        return;
    }
    
    NSLog(@"key:%@",[NSString stringWithFormat:@"%@",currentKey]);
    NSLog(@"version:%@",currentKey.version);
    
    if (currentKey.isAdmin) {
        
        if (isInitPsPool) {
            
            //初始化900密码
            [s initUserKeyboardPS_password:currentKey.password key:currentKey.key aesKey:currentKey.aseKey version:currentKey.version unlockFlag:currentKey.unlockFlag];
            
        }else if (currentKey.adminKeyboardPsTmp && currentKey.adminKeyboardPsTmp.length>0) {
            
            //管理员设置键盘密码
            NSLog(@"设置管理员键盘密码");
            [s setAdminKeyBoardPassword:currentKey.adminKeyboardPsTmp key:currentKey.key password:currentKey.password aesKey:currentKey.aseKey version:currentKey.version unlockFlag:currentKey.unlockFlag];
            
        }else if (currentKey.deletePsTmp && currentKey.deletePsTmp.length>0) {
            
            //管理员设置键盘密码
            NSLog(@"设置管理员键盘密码");
            [s setAdminDeleteKeyBoardPassword:currentKey.deletePsTmp key:currentKey.key password:currentKey.password aesKey:currentKey.aseKey version:currentKey.version unlockFlag:currentKey.unlockFlag];
            
        }else{
            
            //管理员开门
            NSLog(@"管理员开门");
            [s unlockAdmin_password:currentKey.password key:currentKey.key aesKey:currentKey.aseKey version:currentKey.version unlockFlag:currentKey.unlockFlag];
        }
        
    }else{
        
//        NSDate * startDate = [XYCUtils formateDateFromStringToDate:@"201510101010" format:@"yyyyMMddHHmm"].timeIntervalSince1970;
//        NSDate * endDate = [XYCUtils formateDateFromStringToDate:@"202010101010" format:@"yyyyMMddHHmm"].timeIntervalSince1970;
        
        NSLog(@"unlockflag:%i,aes:%@",currentKey.unlockFlag,currentKey.aseKey);
        [XYCUtils printByteByByte:currentKey.aseKey.bytes withLength:currentKey.aseKey.length];
        
        //ekey开门
        [s unlockEKey_key:currentKey.key startDate:[NSDate dateWithTimeIntervalSince1970:currentKey.startDate] endDate:[NSDate dateWithTimeIntervalSince1970:currentKey.endDate] aesKey:currentKey.aseKey version:currentKey.version unlockFlag:currentKey.unlockFlag];
        
        
    }
    
}

-(void)setDisconnect:(NSString*)lockName
{
    
    NSLog(@"断开蓝牙 disconnect");
    
    [s scan];
}

@end
