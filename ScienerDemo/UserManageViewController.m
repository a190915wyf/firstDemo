//
//  UserManageViewController.m
//  BTstackCocoa
//
//  Created by wan on 13-3-6.
//
//

#import "UserManageViewController.h"
#import "RequestService.h"
#import "AppDelegate.h"
#import "Define.h"
#import "UserManageCell.h"
#import "UserInfo.h"
#import "XYCUtils.h"
#import "ProgressHUD.h"

@interface UserManageViewController ()
{
    
    UserInfo * selectedUser;
}

@end


@implementation UserManageViewController

@synthesize currentKey;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"keydetail_item_title_manage", nil);
        
        
        //防止在ios7上出现，tableview被nav遮住的情况
        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending)
        {
            // OS version >= 7.0
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
}

-(void)gotUsers:(NSMutableArray*)usersGot success:(BOOL)success isFromNet:(BOOL)isFromNet
{
   
    if (usersGot) {
        
        if ([usersGot count]>0) {
            
            [label_no_user setHidden:YES];
        }else{
            
            [label_no_user setHidden:NO];
        }
        users = usersGot;
        
    }else{
        
        [label_no_user setHidden:NO];
    }

    
    [customTableView reloadData];
    [aiv stopAnimating];
    [aiv setHidden:YES];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [label_no_user setText:NSLocalizedString(@"words_no_user", Nil)];
    [label_no_user setHidden:YES];
    
    
}

-(void)reloadData{

    if (users != nil) {
        [users removeAllObjects];
        [customTableView reloadData];
    }
    
    [aiv setHidden:NO];
    
    [aiv startAnimating];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(queue, ^(void){
        
        dispatch_sync(queue, ^(void){
            
            AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            users = [RequestService requetRoomUsers_roomID:currentKey.roomid clientid:kScienerAppkey accesstoken:appDelegate.s.accessToken];
            
        });
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            
            [self gotUsers:users success:YES isFromNet:YES];
            
        });
    });

}

-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (users != nil) {
        [users removeAllObjects];
        [customTableView reloadData];
    }
    
    
    [self reloadData];

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!users) {
        
        return 0;
    }
    
    return [users count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"managecell";
    
    UserManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserManageCell"
                                              owner:self
                                            options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    UserInfo *user = [users objectAtIndex:indexPath.row];
    
    cell.label_left.text = [NSString stringWithFormat:@"用户ID:%@",user.openid];
    
    if (user.startDate == user.endDate) {
        
        cell.label_bottom.text = NSLocalizedString(@"words_e_key_forever", nil);
        
    }else{
        
        cell.label_bottom.text = [NSString stringWithFormat:@"有效时间：%@--%@",[XYCUtils formateDate:user.startDate format:@"yyyy/MM/dd HH:mm"],[XYCUtils formateDate:user.endDate format:@"yyyy/MM/dd HH:mm"]];
        
    }
    
    cell.label_right.text = [NSString stringWithFormat:@"用户状态:%@",user.status];
    
    return cell;
    
}


#pragma mark - Table view delegate

-(NSIndexPath * )tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedUser =[users objectAtIndex:indexPath.row];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:NSLocalizedString(@"words_operate", nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"words_delete", nil),NSLocalizedString(@"words_blocked", nil),NSLocalizedString(@"words_unblocked", nil),nil];
    //展示actionSheet
    actionSheet.tag = indexPath.row;
    [actionSheet showInView:self.view];
    
    NSLog(@"will selected");
    
    return Nil;
}

-(void)cancelAlert
{
    
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;//这句很重要，去掉的话，alertview不为null，即使已经dealloc
        
    }
    
}

-(void)showAlert
{
    
    if(alertView&&!alertView.isHidden){
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;
        
    }
    
    alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"words_wait_please", "moment please...")
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles: nil];
    [alertView show];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 3:
            
            //取消按钮
            return;
            
            break;
        case 2:
            
        {
            
            //解除冻结
            
            [ProgressHUD show:@"请稍候..."];
//            [self showAlert];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            
            __block int ret;
            dispatch_async(queue, ^(void){
                
                dispatch_sync(queue, ^(void){
                    
                    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    ret = [RequestService unblockUser_kid:selectedUser.kid.intValue roomID:selectedUser.roomid.intValue openid:selectedUser.openid clientid:kScienerAppkey accesstoken:appDelegate.s.accessToken];
                    
                });
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    
                    [ProgressHUD dismiss];
                    if (ret == 0) {
                        
                        
                        UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"words_unblock_success", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                        [alertViewtmp show];
                        alertViewtmp.tag = 100;
                        
                        [self reloadData];
                        
                    }else{
                        
                        UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"words_unblock_fail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                        alertViewtmp.tag = 100;
                        [alertViewtmp show];
                        
                    }
                    
                });
            });
            
            break;
        }
            
        case 1:
        {
            
            [ProgressHUD show:@"请稍候..."];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            
            __block int ret;
            dispatch_async(queue, ^(void){
                
                dispatch_sync(queue, ^(void){
                    
                    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    ret = [RequestService blockUser_kid:selectedUser.kid.intValue roomID:selectedUser.roomid.intValue openid:selectedUser.openid clientid:kScienerAppkey accesstoken:appDelegate.s.accessToken];
                    
                    
                });
                
                
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    
                    [ProgressHUD dismiss];
                    
                    if (ret == 0) {
                        
                        
                        UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"words_block_success", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                        alertViewtmp.tag = 100;
                        [alertViewtmp show];
                        
                        
                        [self reloadData];
                        
                    }else{
                        
                        UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"words_block_fail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                        alertViewtmp.tag = 100;
                        [alertViewtmp show];
                        
                    }
                    
                });
            });
            
            
            break;
        }
        case 0:
        {
            
            [ProgressHUD show:@"请稍候..."];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            
            __block int ret;
            dispatch_async(queue, ^(void){
                
                dispatch_sync(queue, ^(void){
                    
                    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    ret = [RequestService deleteUser_kid:selectedUser.kid.intValue roomID:selectedUser.roomid.intValue openid:selectedUser.openid clientid:kScienerAppkey accesstoken:appDelegate.s.accessToken];
                    
                });
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    
                    [ProgressHUD dismiss];
                    
                    if (ret == 0) {
                        
                        UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:@"删除成功" delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                        alertViewtmp.tag = 100;
                        [alertViewtmp show];
                        
                        [self reloadData];
                        
                    }else{
                        
                        
                        UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"words_delete_fail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                        alertViewtmp.tag = 100;
                        [alertViewtmp show];
                        
                    }
                    
                });
            });
            
            break;
        }
        default:
            break;
    }
    
}

@end
