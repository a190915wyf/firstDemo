//
//  AddLockGuider1ViewController.h
//  BTstackCocoa
//
//  Created by wan on 13-2-21.
//
//

#import <UIKit/UIKit.h>
#import "sciener.h"

@protocol BTDiscoveryDelegate;

typedef enum {
	kInquiryInactive,
	kInquiryActive,
	kInquiryRemoteName
} InquiryState;

@interface AddLockGuider1ViewController : UIViewController<UIAlertViewDelegate,ScienerSDKDelegate,UIActionSheetDelegate>
{
    
    IBOutlet UITableView *tableViewCustom;
   
	UIActivityIndicatorView *deviceActivity;
	UIActivityIndicatorView *bluetoothActivity;
    
    UIAlertView *alertView;
    
}

-(void) markConnecting:(int)index; // use -1 for no connection active
@property (nonatomic, assign) NSObject<BTDiscoveryDelegate> * delegate;
@property (nonatomic, assign) BOOL showIcons;
@property (nonatomic, retain) NSString *customActivityText;

-(void)searchAction;

+(AddLockGuider1ViewController*) sharedInstance;
-(void)showAlert;
-(void)cancelAlert;

-(void)connectTimeOut;



//sciener delegate

//指令功能相关回调
-(void)gotLockVersion:(int)version;
-(void)addAdminSuccess_password:(NSString*)password key:(NSString*)key aesKey:(NSData*)aesKeyData version:(NSString*)versionStr mac:(NSString*)mac;
-(void)scienerError:(ScienerError)error;
-(void)calibationTimeSuccess;
-(void)unlockSuccess;
-(void)setAdminKeyboardPasswordSuccess;

//蓝牙搜索，连接相关回调
-(void)peripheralFound:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary*)advertisementData;
-(void)setConnect:(CBPeripheral *)peripheral lockName:(NSString*)lockName;
-(void)setDisconnect:(NSString*)lockName;





@end


