//
//  FirstViewController.m
//  sciener
//
//  Created by wan on 13-1-21.
//  Copyright (c) 2013年 wan. All rights reserved.
//

#import "Tab0ViewController.h"
#import "DBHelper.h"
#import "Tab0ViewCell.h"
#import "MyLog.h"
#import "KeyDetailViewController.h"
#import "RequestService.h"
#import "AddLockGuider1ViewController.h"
#import "AppDelegate.h"
#import "Define.h"

@interface Tab0ViewController()
{
    
    UIView * loadingView;
    
    Key * currentKey;
    
    NSMutableArray *keyArray;
    NSMutableArray *ekeyArray;
    
}

@end


@implementation Tab0ViewController

@synthesize customTableView;

bool DEBUG_TAB0 = true;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"tab0_title", @"sciener");
        
        //左边按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"科技侠登录" style:UIBarButtonItemStylePlain target:self action:@selector(gotoSciener:)];
        
        //右边按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)];
        
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

-(void)rightAction:(id)sender
{
    
//    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (!delegate.s.accessToken) {
//        
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请先点击左侧‘登录’按钮，获取accesstoken" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        return;
//    }
    
    [self.navigationController pushViewController:[[AddLockGuider1ViewController alloc] initWithNibName:@"AddLockGuider1ViewController" bundle:nil] animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setExtraCellLineHidden:customTableView];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    ekeyArray = [[NSMutableArray alloc]init];
    keyArray = [[NSMutableArray alloc]init];
    
    [self getData];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
}


-(void)getData
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(queue, ^(void){
        
        dispatch_sync(queue, ^(void){
            
            DBHelper *dbHelper = [DBHelper sharedInstance];
            keyArray = [dbHelper fetchKeys];
            
            
            for (Key * key in keyArray) {
                
               [MyLog log:[NSString stringWithFormat:@"key:%@,kid:%i,roomid:%i",key.key,key.kid,key.roomid] isdebug:YES];
            }
        });
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            
            [customTableView reloadData];
            
        });
        
    });
    
    
    //下载电子钥匙列表
    {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        
        dispatch_async(queue, ^(void){
            
            dispatch_sync(queue, ^(void){
                
                AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                ekeyArray = [RequestService requestEkeys_clientid:kScienerAppkey accesstoken:delegate.s.accessToken];
                
                for (Key * key in ekeyArray) {
                    
                    [MyLog log:[NSString stringWithFormat:@"获取到的ekey，key:%@,kid:%i,roomid:%i",key.lockName,key.kid,key.roomid] isdebug:YES];
                }
                
            });
            
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                
                [customTableView reloadData];
                
            });
            
        });
        
    }
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}


- (void)didReceiveMemoryWarning
{
    
    NSLog(@"tab0 ####didReceiveMemoryWarning####");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)  tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        if (indexPath.row<[keyArray count]) {
            
            
            Key* key = [keyArray objectAtIndex:indexPath.row];
            
            [[DBHelper sharedInstance]deleteKey:key];
            
            //界面删除
            [keyArray removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationLeft];
            
            
            
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        Tab0ViewCell* cell = (Tab0ViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        BOOL editing = [cell isEditing];
        
        
        return !editing;
    }
    
    return NO;
    
    
    
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            
            return [keyArray count];
            break;
        case 1:
            
            return [ekeyArray count];
            break;
        case 2:
            
            return 3;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    Tab0ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Tab0ViewCell"
                                              owner:self
                                            options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    switch (indexPath.section) {
        case 0:
        {
        
            Key *key = [keyArray objectAtIndex:indexPath.row];
            
            cell.label_key_name.text = key.doorName;
            
            if([key isAdmin]){
                
                cell.label_user_type.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"words_shenfen", @"identity"),NSLocalizedString(@"words_admin", @"admin")];
                
            }else{
                
                cell.label_user_type.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"words_shenfen", @"identity"),NSLocalizedString(@"words_user", @"user")];
                
            }
            
            BOOL outOfDate = YES;
            NSDate * currentDate = [NSDate date];
            
            if ([[currentDate earlierDate:[NSDate dateWithTimeIntervalSince1970:key.endDate]]isEqual:currentDate]) {
                
                outOfDate = NO;
            }
            
            break;
            
        }
        case 1:
        {
            
            Key *key = [ekeyArray objectAtIndex:indexPath.row];
            
            cell.label_key_name.text = key.doorName;
            
            if([key isAdmin]){
                
                cell.label_user_type.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"words_shenfen", @"identity"),NSLocalizedString(@"words_admin", @"admin")];
                
            }else{
                
                cell.label_user_type.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"words_shenfen", @"identity"),NSLocalizedString(@"words_user", @"user")];
                
            }
            
            BOOL outOfDate = YES;
            NSDate * currentDate = [NSDate date];
            
            if ([[currentDate earlierDate:[NSDate dateWithTimeIntervalSince1970:key.endDate]]isEqual:currentDate]) {
                
                outOfDate = NO;
            }
            
            break;
            
        }
        case 2:
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    cell.label_key_name.text = delegate.s.openID;
                    cell.label_user_type.text = @"OpenId";
                    break;
                }
                case 1:
                    
                    cell.label_key_name.text = kScienerAppkey;
                    cell.label_user_type.text = @"AppKey";
                    
                    break;
                case 2:
                {
                    
                    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    cell.label_key_name.text = delegate.s.accessToken;
                    cell.label_user_type.text = @"AccessToken";
                    break;
                }
                default:
                    break;
            }
            
            break;
            
        default:
            break;
    }
    
    
    
    
    
    return (UITableViewCell *) cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        extern Key* selectedKey;
        selectedKey = [keyArray objectAtIndex:indexPath.row];
        
        KeyDetailViewController *uiview = [[KeyDetailViewController alloc]initWithNibName:@"KeyDetailViewController" bundle:nil];
        [self.navigationController pushViewController:uiview animated:YES];
        
    }else if(indexPath.section == 1){
        
        //ekey
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        
        dispatch_async(queue, ^(void){
            
            __block KeyModel* selectedKey;
            __block int ret;
            
            dispatch_sync(queue, ^(void){
                
                AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                selectedKey = [ekeyArray objectAtIndex:indexPath.row];
                
                ret = [RequestService downloadEkey_key:selectedKey clientid:kScienerAppkey accesstoken:delegate.s.accessToken];
                
                NSLog(@"aeskey:%@",selectedKey.aseKey);
                
                [[DBHelper sharedInstance]saveKey:selectedKey];
                
            });
            
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                
                if (ret==0) {
                    
                    //下载成功
                    [ekeyArray removeAllObjects];
                    [keyArray removeAllObjects];
                    [customTableView reloadData];
                    
                    [self getData];
                }
                
            });
            
        });
        
    }
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
            
        case 0:
            
            return @"已添加钥匙";
            
            break;
            
        case 1:
            
            return @"eKey";
            
            break;
            
        case 2:
            
            return @"账号信息";
            
            break;
            
        default:
            
            break;
            
    }
    
    return nil;
}


-(IBAction)gotoSciener:(id)sender
{
    
    AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.s authorize];
}

@end
