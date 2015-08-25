//
//  AppDelegate.h
//  ScienerDemo
//
//  Created by 谢元潮 on 14-10-29.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sciener.h"
#import "Key.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,ScienerSDKDelegate>
{
    
    Key * currentKey;
    UIAlertView * alertView;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Sciener* s;
//@property (nonatomic) BOOL isCalibationLockDate;


-(void)cancelAlert;
-(void)showAlertTitle:(NSString*)title msg:(NSString*)msg;




//相关回调
-(void)scienerError:(ScienerError)error;

-(void)gotLockVersion:(NSString*)versionStr;
-(void)addAdminSuccess_password:(NSString*)password key:(NSString*)key aesKey:(NSData*)aesKeyData version:(NSString*)versionStr mac:(NSString*)mac;
-(void)calibationTimeSuccess;
-(void)unlockSuccess;
-(void)setAdminKeyboardPasswordSuccess;
-(void)setUserKeyBoardPasswordSuccess;
-(void)clearUserKeyBoardPasswordSuccess;
-(void)deleteUserKeyBoardPasswordSuccess;
-(void)clearLockSuccess;    //清空锁
-(void)renameLockSuccess;   //重命名
-(void)getKeyboardPs_type:(KeyboardPsType)type password:(NSString*)password times:(int)times startDate:(NSDate*)startDate endDate:(NSDate*)endDate isLast:(BOOL)isLast;   //获取到键盘密码
-(void)getPower:(float)power; //电量

//蓝牙搜索，连接相关回调
-(void)peripheralFound:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary*)advertisementData;
-(void)setConnect:(CBPeripheral *)peripheral lockName:(NSString*)lockName;
-(void)setDisconnect:(NSString*)lockName;



@end

