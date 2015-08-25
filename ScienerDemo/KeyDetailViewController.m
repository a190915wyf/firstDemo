//
//  KeyDetailViewController.m
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import "KeyDetailViewController.h"
#import "Key.h"
#import "MyLog.h"
#import "KeyDetailCell.h"
#import "DBHelper.h"
#import "XYCUtils.h"
#import "AppDelegate.h"
#import "RequestService.h"
#import "Define.h"
#import "UnlockRecordsViewController.h"
#import "UserManageViewController.h"
#import "ProgressHUD.h"
#import "KeyboardPsManageViewController.h"
#import "KeyBoardPsEditViewController.h"

@interface KeyDetailViewController ()
{

    UIAlertView * alert4Test;
    
    IBOutlet UIView * psPoolProgressView;
    IBOutlet UISlider * psPoolSlider;
    
}

@end

Key* selectedKey = nil;

#define TAG_SET_KEYBOARD_PS 1
#define TAG_Calibation_Lock_Date 2
#define TAG_SEND_EKEY 3
#define TAG_SET_KEYBOARD_PS_DELETE 4
#define TAG_SET_INIT_900_PS 5


#define TAG_SHEET_RESET_900_PS 1

@implementation KeyDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        if(selectedKey.doorName){
        
            self.title = selectedKey.doorName;
        }else{
        
            self.title=@"Key Detail";
        }
        
        //防止在ios7上出现，tableview被nav遮住的情况
        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending)
        {
            // OS version >= 7.0
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        
        self.hidesBottomBarWhenPushed = YES;
    }
    
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.s.delegate = appDelegate;
    
}

-(void)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
}

-(void)viewDidDisAppear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    self.title = selectedKey.doorName;
    [customTableView reloadData];
    
    [super viewWillAppear:animated];
    
    if (selectedKey.isShared || !selectedKey.isAdmin) {
        
        customTableView.tableFooterView = NULL;
        
    }
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    [psPoolSlider setHidden:YES];
    [psPoolProgressView setHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (selectedKey.isAdmin) {
        
        if ([selectedKey.version isEqualToString:@"5.1.1.1.1"]) {
            
            return 6;
        }else{
            
            return 7;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
            
        case 0:
            if (!selectedKey.isAdmin) {
                
                return 2;
            }
            return 1;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return 1;
            break;
            
        case 4:
            return 1;
            break;
            
        case 5:
            
            return 3;
            
            break;

        case 6:
            return 4;
            break;
            
        default:
            
            break;
            
    }
    
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"keydetailcell";
    
    KeyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KeyDetailCell"
                                              owner:self
                                            options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    [cell.img_right_top setHidden:YES];
    [cell.slider setHidden:YES];
    [cell.label_right setTag:0];
    
    switch (indexPath.section) {
        case 0:
            
            switch (indexPath.row) {
                case 0:
                    
                    if (selectedKey.isAdmin) {
                        
                        [cell.switch_right removeFromSuperview];
                        
                        cell.label_left.text = @"发送电子钥匙";
                        
                        [cell.label_right setHidden:YES];
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        
                        [cell.switch_right removeFromSuperview];
                        
                        cell.label_left.text = @"开始时间";
                        
                        cell.label_right.text = [XYCUtils formateDate:[NSDate dateWithTimeIntervalSince1970:selectedKey.startDate] format:@"yyyy-MM-dd HH:mm"];
                        
                    }
                    break;
                    
                case 1:
                    
                    [cell.switch_right removeFromSuperview];
                    
                    cell.label_left.text = @"结束时间";
                    
                    cell.label_right.text = [XYCUtils formateDate:[NSDate dateWithTimeIntervalSince1970:selectedKey.endDate] format:@"yyyy-MM-dd HH:mm"];
                    
                    break;
                    
                default:
                    
                    break;
            }
            
            
            break;
        case 1:
            
            switch (indexPath.row) {
                case 0:
                    
                    
                    [cell.switch_right setTag:1];
                    
                    cell.label_left.text = @"设置管理员键盘密码";
                    cell.label_right.text = selectedKey.adminKeyboardPs;
                    
                    [cell.switch_right setHidden:YES];
                    
                    break;
                case 1:
                {
                
                    
                    cell.label_left.text = NSLocalizedString(@"＃测试＃", nil);
                    
                    cell.label_right.text = @"同步900个密码";
                    
                    [cell.switch_right setHidden:YES];
                    
                    break;
                }
                case 2:
                {
                    
                    
                    cell.label_left.text = NSLocalizedString(@"＃测试＃", nil);
                    
                    cell.label_right.text = @"同步有效密码序列";
                    
                    [cell.switch_right setHidden:YES];
                    
                    break;
                }
                case 3:
                {
                    
                    
                    cell.label_left.text = NSLocalizedString(@"＃测试＃", nil);
                    
                    cell.label_right.text = @"失效flag ＋1";
                    
                    [cell.switch_right setHidden:YES];
                    
                    break;
                }
                case 4:
                {
                    
                    
                    cell.label_left.text = NSLocalizedString(@"＃测试＃", nil);
                    
                    cell.label_right.text = @"设置删除当前有效密码的密码";
                    
                    [cell.switch_right setHidden:YES];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        case 2:
            cell.label_left.text = @"校准时钟";
            
            cell.label_right.text = @"";
            
            [cell.switch_right setHidden:YES];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            break;
        case 3:
            cell.label_left.text = @"读取开锁记录";
            
            cell.label_right.text = @"";
            
            [cell.switch_right setHidden:YES];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            break;
        case 4:
            cell.label_left.text = @"锁用户";
            
            cell.label_right.text = @"";
            
            [cell.switch_right setHidden:YES];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            break;
        case 5:
        {
            
            cell.label_right.text = @"";
            
            [cell.switch_right setHidden:YES];
            
            if ([selectedKey.version isEqualToString:@"5.1.1.1.1"]) {
                
                switch (indexPath.row) {
                    case 0:
                    {
                        //初始化键盘密码
                        cell.label_left.text = @"初始化键盘密码";
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        break;
                    }
                    case 1:
                    {
                        //发送键盘密码
                        cell.label_left.text = @"发送键盘密码";
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        break;
                    }
                    case 2:
                    {
                        //管理员删除密码
                        cell.label_left.text = @"管理员删除密码";
                        cell.label_right.text = selectedKey.deletePs;
                        
                        break;
                    }
                    default:
                        break;
                }
            }else{
                
                switch (indexPath.row) {
                    case 0:
                    {
                        //增加键盘密码
                        cell.label_left.text = @"增加键盘密码";
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        break;
                    }
                    case 1:
                    {
                        //读取键盘密码
                        cell.label_left.text = @"读取键盘密码";
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        break;
                    }
                    case 2:
                    {
                        //清空键盘密码
                        cell.label_left.text = @"清空键盘密码";
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        break;
                    }
                    default:
                        break;
                }
            }
            
            break;
            
        }
        case 6:
        {
            //远程操作
            switch (indexPath.row) {
                case 0:
                {
                    //远程开门
                    [cell.switch_right removeFromSuperview];
                    [cell.label_right removeFromSuperview];
                    cell.label_left.text = @"远程开门";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:
                {
                    //读取设备状态
                    [cell.switch_right removeFromSuperview];
                    [cell.label_right removeFromSuperview];
                    cell.label_left.text = @"读取设备状态";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:
                {
                    //键盘密码管理
                    [cell.switch_right removeFromSuperview];
                    [cell.label_right removeFromSuperview];
                    cell.label_left.text = @"键盘密码管理";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    break;
                }
                case 3:
                {
                    //设置门锁开门标志位
                    [cell.switch_right removeFromSuperview];
                    [cell.label_right removeFromSuperview];
                    cell.label_left.text = @"设置门锁开门标志位";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    break;
                }
                default:
                    break;
            }
            
            
        }
        default:
            break;
    }
    
    return (UITableViewCell *) cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44.0f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([selectedKey.version isEqualToString:@"5.1.1.1.1"] && indexPath.section == 5) {
     
        //2s
        switch (indexPath.row) {
            case 0:
            {
                
                //初始化900密码
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"重置用户密码，选择重置之后，之前发送给用户的密码都将失效。是否重置用户密码？"
                                              delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"重置", nil];
                //展示actionSheet
                //        [actionSheet showFromTabBar:self.tabBarController.tabBar];
                [actionSheet showInView:self.view];
                actionSheet.tag = TAG_SHEET_RESET_900_PS;
                
                break;
            
            }
            case 1:
                //发送键盘密码
                
                break;
            case 2:
            {
                //管理员删除密码
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请输入管理员删除密码(6到10位数字)"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                      otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                
                alert.tag = TAG_SET_KEYBOARD_PS_DELETE;
                [alert show];
                break;

            }
            default:
                break;
        }
        return nil;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        //发送电子钥匙
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请输入接受方id(方便起见，这里默认发送电子钥匙的有效期是从当前时间开始的后20分种)"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        alert.tag = TAG_SEND_EKEY;
        [alert show];
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        
        //设置键盘密码
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请输入键盘密码(6到10位数字)"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        alert.tag = TAG_SET_KEYBOARD_PS;
        [alert show];

    }else if (indexPath.section == 2 && indexPath.row == 0) {
        
        //校准时间
        
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [appDelegate showAlertTitle:@"校准时间" msg:@""];
        
    }else if (indexPath.section == 3 && indexPath.row == 0) {
        
        //读取开锁记录
        
        UnlockRecordsViewController * unlockRecord = [[UnlockRecordsViewController alloc]initWithNibName:@"UnlockRecordsViewController" bundle:nil];
        unlockRecord.roomid = selectedKey.roomid;
        [self.navigationController pushViewController:unlockRecord animated:YES];
    }else if (indexPath.section == 4 && indexPath.row == 0) {
        
        //所用户
        
        UserManageViewController * unlockRecord = [[UserManageViewController alloc]initWithNibName:@"UserManageViewController" bundle:nil];
        unlockRecord.currentKey = selectedKey;
        [self.navigationController pushViewController:unlockRecord animated:YES];
    }else if (indexPath.section == 5 && indexPath.row == 0)
    {
        
        //添加新密码
        
        KeyBoardPsEditViewController * keyboardEdit = [[KeyBoardPsEditViewController alloc] initWithNibName:@"KeyBoardPsEditViewController" bundle:nil];
        keyboardEdit.isSendNewKeyboardPs = YES;
        keyboardEdit.isLocal = YES;
        [self.navigationController pushViewController:keyboardEdit animated:YES];

    }else if (indexPath.section == 5 && indexPath.row == 1)
    {
        
        
        KeyboardPsManageViewController * keyboardPsM = [[KeyboardPsManageViewController alloc]initWithNibName:@"KeyboardPsManageViewController" bundle:nil];
        [self.navigationController pushViewController:keyboardPsM animated:YES];
        
        
    }else if (indexPath.section == 5 && indexPath.row == 2)
    {
        
        [ProgressHUD show:@"请稍候..."];
        
        AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        [delegate.s clearUserKeyboardPs_password:selectedKey.password key:selectedKey.key aesKey:selectedKey.aseKey version:selectedKey.version unlockFlag:selectedKey.unlockFlag];
        
    }
    
    return nil;
}

-(void)alertView:(UIAlertView *)alertViewT clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertViewT.tag == TAG_SET_INIT_900_PS) {
        
        extern BOOL isInitPsPool;
        
        isInitPsPool = NO;
        
    }
    
    if (buttonIndex == 1) {
        
        switch (alertViewT.tag) {
            
            case TAG_SEND_EKEY:
            {
            
                [ProgressHUD show:@"请稍候..."];
                
                //接收者的唯一name
                NSString * receiver = [alertViewT textFieldAtIndex:0].text;
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                
                __block int ret ;
                
                dispatch_async(queue, ^(void){
                    
                    dispatch_sync(queue, ^(void){
                        
                        
                        NSString *startDate = [XYCUtils GetCurrentTimeInMillisecond];
                        long long startDateInt = startDate.longLongValue;
                        NSString * endDate = [NSString stringWithFormat:@"%lli",startDateInt+1200000];
                        
                        AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                        NSString * adminid =delegate.s.openID;
                        NSString * accessToken =delegate.s.accessToken;
                        
                        NSString * str = @"这是一把钥匙";
                        
                        ret = [RequestService SendEKey_roomid:[NSString stringWithFormat:@"%i",selectedKey.roomid] startDate:startDate endDate:endDate key:selectedKey.key mac:@"123" message:str clientid:kScienerAppkey accessToken:accessToken openid:receiver];
                        
                    });
                    
                    dispatch_sync(dispatch_get_main_queue(), ^(void){
                        
                        
                        [ProgressHUD dismiss];
                        NSLog(@"ret:%i",ret);
                        
                        
                        
                    });
                });
                
                break;
            }
            case TAG_SET_KEYBOARD_PS:
            {
                //设置管理员密码
                
                NSString * ps = [alertViewT textFieldAtIndex:0].text;
                
                
                if ([XYCUtils checkNokeyPassword:ps]) {
                    
                    selectedKey.adminKeyboardPsTmp = ps;
                    [[DBHelper sharedInstance] update];
                    
                    [customTableView reloadData];
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您设置的键盘密码将在下次开门之后生效" message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", "OK") otherButtonTitles:nil];
                    
                    [alert show];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:@"键盘密码必须由6到10位数字组成" delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil];
                    
                    [alert show];
                    
                }
                
                break;
            }
            case TAG_SET_KEYBOARD_PS_DELETE:
            {
                //设置管理员删除密码
                
                NSString * ps = [alertViewT textFieldAtIndex:0].text;
                
                
                if ([XYCUtils checkNokeyPassword:ps]) {
                    
                    selectedKey.deletePsTmp = ps;
                    [[DBHelper sharedInstance] update];
                    
                    [customTableView reloadData];
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您设置的管理员删除密码将在下次开门之后生效" message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", "OK") otherButtonTitles:nil];
                    
                    [alert show];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:@"管理员删除密码必须由6到10位数字组成" delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil];
                    
                    [alert show];
                    
                }
                
                break;
            }
            case TAG_Calibation_Lock_Date:
            {
            
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您在下次开门到时候将进行时间校准" message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", "OK") otherButtonTitles:nil];
                
                [alert show];
                
                break;
            }
            default:
                break;
        }
        
    }
    
}

-(void)cancelAlert
{
    
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //重置键盘密码
    if (actionSheet.tag == TAG_SHEET_RESET_900_PS) {
        
        if (!buttonIndex) {
            
            extern BOOL isInitPsPool;
            isInitPsPool = YES;
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"重置用户密码，请按下开锁按钮。"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
            alert.tag = TAG_SET_INIT_900_PS;
            [alert show];
            
            
        }
        
    }
}

@end
