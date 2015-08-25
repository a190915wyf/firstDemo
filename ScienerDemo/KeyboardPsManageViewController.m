//
//  KeyboardPsManageViewController.m
//  sciener
//
//  Created by 谢元潮 on 15/3/27.
//
//

#import "KeyboardPsManageViewController.h"
#import "AddLockGuider1Cell.h"
#import "KeyBoardPsEditViewController.h"
#import "ProgressHUD.h"
#import "XYCUtils.h"

@interface KeyboardPsManageViewController ()
{

//    UIAlertView * alertView;
    
    AppDelegate * delegate;
    
    NSMutableArray * psArray;
    
    KeyboardPs * selectedPs;
    
    IBOutlet UILabel* mLabelNoData;
    IBOutlet UIActivityIndicatorView * mIndicatorView;
    
}

////相关回调
//-(void)scienerError:(ScienerError)error;
//
//-(void)gotLockVersion:(NSString*)versionStr;
//-(void)addAdminSuccess_password:(NSString*)password key:(NSString*)key aesKey:(NSData*)aesKeyData version:(NSString*)versionStr mac:(NSString*)mac;
//-(void)calibationTimeSuccess;
//-(void)unlockSuccess;
//-(void)setAdminKeyboardPasswordSuccess;
//-(void)setUserKeyBoardPasswordSuccess;
//-(void)clearUserKeyBoardPasswordSuccess;
//-(void)deleteUserKeyBoardPasswordSuccess;
//-(void)clearLockSuccess;    //清空锁
//-(void)renameLockSuccess;   //重命名
//-(void)getKeyboardPs_type:(KeyboardPsType)type password:(NSString*)password times:(int)times startDate:(NSDate*)startDate endDate:(NSDate*)endDate isLast:(BOOL)isLast;   //获取到键盘密码
//-(void)getPower:(float)power; //电量
//
////蓝牙搜索，连接相关回调
//-(void)peripheralFound:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary*)advertisementData;
//-(void)setConnect:(CBPeripheral *)peripheral lockName:(NSString*)lockName;
//-(void)setDisconnect:(NSString*)lockName;


@end


@implementation KeyboardPsManageViewController

@synthesize isLocal;

#define TAG_SHEET_KEY_BOARD_OPERATE 1

KeyboardPsManageViewController * instanceKb=nil;

+(KeyboardPsManageViewController *) sharedInstance {
    
    return instanceKb;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"键盘密码管理";
        
    }
    
    return self;
    
}

-(void)rightAction:(id)sender
{
    
    KeyBoardPsEditViewController * keyboardEdit = [[KeyBoardPsEditViewController alloc] initWithNibName:@"KeyBoardPsEditViewController" bundle:nil];
    keyboardEdit.isSendNewKeyboardPs = YES;
    keyboardEdit.isLocal = isLocal;
    
    [self.navigationController pushViewController:keyboardEdit animated:YES];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    instanceKb = self;
    
    [mLabelNoData setHidden:YES];
    
    [mIndicatorView setHidden:NO];
    
    [mIndicatorView startAnimating];
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
//    if (isLocal) {
    
        //本地读取
        extern Key * selectedKey;
    
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
        [delegate.s getUserKeyboardPs_password:selectedKey.password key:selectedKey.key aesKey:selectedKey.aseKey version:selectedKey.version unlockFlag:selectedKey.unlockFlag];
    
    //右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)];
    
    //防止在ios7上出现，tableview被nav遮住的情况
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
    
//    }else{
//
//        [self getData];
//        
//        //右边按钮
//        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)]autorelease];
//        
//        //防止在ios7上出现，tableview被nav遮住的情况
//        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
//        if (order == NSOrderedSame || order == NSOrderedDescending)
//        {
//            // OS version >= 7.0
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//        }
//
//    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

//-(void)getData{
//
//    __block id ret;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    dispatch_async(queue, ^(void){
//        
//        dispatch_sync(queue, ^(void){
//            
//            //TODO
//            extern Key * selectedKey;
//            ret = [RequestService GetKeyboardPsWithUid:[SettingHelper getUID] password:@"1234567" lockId:[NSString stringWithFormat:@"%i",selectedKey.roomId]];
//            
//        });
//        
//        dispatch_sync(dispatch_get_main_queue(), ^(void){
//            
//            [mIndicatorView setHidden:YES];
//            
//            if (ret && [ret isKindOfClass:[NSMutableArray class]]) {
//                
//                //成功
//                if (psArray!=nil) {
//                    [psArray release];
//                }
//                psArray = (NSMutableArray*)ret;
//                [psArray retain];
//                
//                [mTableView reloadData];
//                if (psArray && psArray.count>0) {
//                    
//                    [mLabelNoData setHidden:YES];
//                }else{
//                    
//                    [mLabelNoData setHidden:NO];
//                }
//                
//            }else{
//                
//                [mLabelNoData setHidden:NO];
//            }
//            
//        });
//        
//    });
//
//}

-(void)getKbPwd:(KeyboardPs*)pwd
{

    if (psArray==nil) {
        
        psArray = [[NSMutableArray alloc]init];
    }
    
    [psArray addObject:pwd];
    
    
    
    NSLog(@"pwd:%@",pwd.keyboardPs);
    
    
}

-(void)getKbPwdFinish:(BOOL)success
{

    [mIndicatorView setHidden:YES];
    if (success) {
        
        //获取数据完毕
        [mTableView reloadData];
        
    }else{
    
        //获取数据失败
        
    }
    
}

-(void)deleteKbPwdSuccess:(BOOL)success
{
    [self cancelAlert];

    if (success) {
        
        [psArray removeObject:selectedPs];
        [mTableView reloadData];
        
    }else{
    
        //失败
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"删除键盘密码失败"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil)
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return psArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"keyboardpsCell";
    
    AddLockGuider1Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddLockGuider1Cell"
                                              owner:self
                                            options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    
    KeyboardPs * ps = [psArray objectAtIndex:indexPath.row];
    
    NSLog(@"ps type:%i",ps.type);
    switch (ps.type) {
//        case KEYBOARD_PS_TYPE_ADMIN:
//            
//            [cell.label_mac setHidden:YES];
//            cell.label_right.text = @"管理员密码";
//            
//            break;
        case KEYBOARD_PS_TYPE_NORMAL_ALL_DATE:
            
            [cell.label_mac setHidden:YES];
            cell.label_right.text = @"永久密码";
            
            break;
        case KEYBOARD_PS_TYPE_LIMITED_DATE:
            
            [cell.label_mac setHidden:NO];
            cell.label_right.text = @"期限密码";
            cell.label_mac.text = [NSString stringWithFormat:@"开始:%@,结束%@",[XYCUtils formateDate:ps.startDate format:@"yyyy年MM月dd日 hh时mm分"],[XYCUtils formateDate:ps.endDate format:@"yyyy年MM月dd日 hh时mm分"]];
            break;
        case KEYBOARD_PS_TYPE_LIMITED_TIMES:
            
            [cell.label_mac setHidden:NO];
            cell.label_right.text = @"次数密码";
            cell.label_mac.text = [NSString stringWithFormat:@"可使用次数:%i",ps.times];
            break;
            
        default:
            break;
    }
    cell.label_left.text = ps.keyboardPs;
    
    
    return (UITableViewCell *) cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    selectedPs = [psArray objectAtIndex:indexPath.row];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"键盘密码操作"
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"删除密码",@"密更新码",nil];
    //展示actionSheet
    //        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet showInView:self.view];
    actionSheet.tag=TAG_SHEET_KEY_BOARD_OPERATE;


}

-(void)cancelAlert
{
    
    [ProgressHUD dismiss];
    [mIndicatorView setHidden:YES];
    
}

-(void)showAlert
{
    
    [ProgressHUD show:NSLocalizedString(@"words_wait_please", "moment please...")];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    
    switch (actionSheet.tag) {
        case TAG_SHEET_KEY_BOARD_OPERATE:
            switch (buttonIndex) {
                case 0:
                {
                    
                    //删除
                    [self showAlert];
                    
//                    if (isLocal) {
                    
                        //本地删除
                        extern Key * selectedKey;
                    
                        [delegate.s deleteUserKeyboardPs_password:selectedKey.password key:selectedKey.key keyboardPsDeli:selectedPs.keyboardPs psType:selectedPs.type aesKey:selectedKey.aseKey version:selectedKey.version unlockFlag:selectedKey.unlockFlag];
                        
//                    }else{
//                    
//                        __block int ret;
//                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//                        dispatch_async(queue, ^(void){
//                            
//                            dispatch_sync(queue, ^(void){
//                                
//                                //TODO
//                                extern Key * selectedKey;
//                                
//                                
//                                ret = [RequestService DeleteKeyboardPsWithUid:[SettingHelper getUID] password:@"1234567" lockId:[NSString stringWithFormat:@"%i",selectedKey.roomId] psId:[NSString stringWithFormat:@"%i",selectedPs.psId] uid:selectedPs.uid];
//                                
//                            });
//                            
//                            dispatch_sync(dispatch_get_main_queue(), ^(void){
//                                
//                                [self cancelAlert];
//                                if (ret == NET_REQUEST_SUCCESS) {
//                                    
//                                    //成功
//                                    [psArray removeObject:selectedPs];
//                                    [mTableView reloadData];
//                                    
//                                    
//                                }else{
//                                    
//                                    
//                                    //失败
//                                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"删除键盘密码失败"
//                                                                                    message:nil
//                                                                                   delegate:self
//                                                                          cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil)
//                                                                          otherButtonTitles:nil];
//                                    
//                                    [alert show];
//                                    
//                                }
//                                
//                            });
//                            
//                        });
//                    }
                    
                    

                    break;
                }
                case 1:
                {
                    
                    //修改
                    
                    KeyBoardPsEditViewController * keyboardEdit = [[KeyBoardPsEditViewController alloc] initWithNibName:@"KeyBoardPsEditViewController" bundle:nil];
                    
                    keyboardEdit.isLocal = isLocal;
                    keyboardEdit.isSendNewKeyboardPs = NO;
                    keyboardEdit.ps = selectedPs;
                    keyboardEdit.psType = selectedPs.type;
                    
                    [self.navigationController pushViewController:keyboardEdit animated:YES];
                    
                    break;
                }
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

-(void)getKeyPassword:(KeyboardPsType)type password:(NSString*)password times:(int)times startDate:(NSDate*)startDate endDate:(NSDate*)endDate isLast:(BOOL)isLast
{
    
    
    if (isLast) {
        
        NSLog(@"获取键盘密码结束");
        
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            
            [self cancelAlert];
            [self getKbPwdFinish:YES];
        });
        
        
    }else{
        
        NSLog(@"获取到键盘密码:%@ 密码type：%i,times:%i",password,type,times);
        KeyboardPs * ps = [[KeyboardPs alloc]init];
        ps.keyboardPs = password;
        ps.type = type;
        ps.startDate = startDate;
        ps.endDate = endDate;
        ps.times = times;
        ps.timesRemain = times;
        
        [self getKbPwd:ps];
        
    }
    
}


////sciener delegate
//
//
//-(void)peripheralFound:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary*)advertisementData
//{
//
//}
//

//
//-(void)setDisconnect:(NSString*)lockName
//{
//
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}
//
//-(void)deleteUserKeyBoardPasswordSuccess
//{
//    
//    NSLog(@"删除成功");
//    
//}
//
//-(void)getPower:(float)power
//{
//
//    NSLog(@"power:%f",power);
//}
//
//-(void)scienerError:(ScienerError)error
//{
//
//    NSLog(@"错误：%li",error);
//}

@end
