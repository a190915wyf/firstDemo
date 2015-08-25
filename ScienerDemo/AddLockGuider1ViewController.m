//
//  AddLockGuider1ViewController.m
//  BTstackCocoa
//
//  Created by wan on 13-2-21.
//
//

#import "AddLockGuider1ViewController.h"
#import "MyLog.h"
#import "AppDelegate.h"
#import "AboutCell.h"
#import "DBHelper.h"
#import "RequestService.h"
#import "Define.h"
#import "XYCUtils.h"

@interface AddLockGuider1ViewController ()
{

    
    NSMutableArray * peripherals;
    
    CBPeripheral * currentPeripheral;
    
    KeyModel *keyAdded;
    
    AppDelegate * delegate;
    
    NSDictionary* currentAdvData;
    
//    NSDictionary * advDataDictionary;
    
}

@end

@implementation AddLockGuider1ViewController
@synthesize showIcons;
@synthesize delegate = _delegate;
@synthesize customActivityText;

static AddLockGuider1ViewController *addLockGuider1Instance=nil;


+(AddLockGuider1ViewController*)sharedInstance
{

    @synchronized(self){  //为了确保多线程情况下，仍然确保实体的唯一性
        
        if (!addLockGuider1Instance) {
            
            addLockGuider1Instance = [[self alloc] init]; //该方法会调用 allocWithZone
            
        }
        
    }
    
    return addLockGuider1Instance;
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self searchAction];
    
}

-(void)viewDidDisappear:(BOOL)animated{

    
    if (addLockGuider1Instance) {
        
        addLockGuider1Instance = nil;
    }
    
    [super viewDidDisappear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        //sciener init
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.s.delegate = self;
        
        peripherals = [[NSMutableArray alloc]init];
    }
    
    
    return self;
}


-(void)showAlert
{
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;//这句很重要，去掉的话，alertview不为null，即使已经dealloc
        
    }
    
    alertView = [[UIAlertView alloc]initWithTitle:@"请稍后..."
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    [alertView show];
    
}

-(void)cancelAlert
{
    
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;//这句很重要，去掉的话，alertview不为null，即使已经dealloc
        
    }
    
    [tableViewCustom reloadData];
    

}


-(void)searchAction
{
    
    [delegate.s scan];
    
}

-(void)nextAction:(id)sender
{
    
    
}

-(void)finishAction:(id)sender
{
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    addLockGuider1Instance = self;
    
    [tableViewCustom reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    delegate.s.delegate = delegate;
    
}
- (void)didReceiveMemoryWarning
{
    NSLog(@"addlock guider 1 ##############didReceiveMemoryWarning###################");
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (peripherals) {
        
        return  peripherals.count;
    }else{
    
        return 0;
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"uitableviewcell");
    
    static NSString *CellIdentifier = @"Celladdlock";
    AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutCell"
                                              owner:self
                                            options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    cell.label_right.text =@"";
    
    CBPeripheral * p = [((NSDictionary*)[peripherals objectAtIndex:indexPath.row]) valueForKey:@"peripheral"];
    
    if (p.isConnected) {
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
    }else{
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    
	cell.label_left.text = p.name;
    
    return (UITableViewCell *) cell;
    
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CBPeripheral* peripheral = [((NSDictionary*)[peripherals objectAtIndex:indexPath.row]) valueForKey:@"peripheral"];
    
    [self performSelector:@selector(connectTimeOut) withObject:nil afterDelay:10];
    
    
    currentAdvData = [((NSDictionary*)[peripherals objectAtIndex:indexPath.row]) valueForKey:@"advertisementdata"];
    
//    [currentAdvData setValue:@"1234123" forKey:@"kCBAdvDataLocalName"];
    
    NSLog(@"选择蓝牙：%@",[currentAdvData objectForKey:@"kCBAdvDataLocalName"]);
    
    [self showAlert];
    [delegate.s stopScan];
    [delegate.s connect:peripheral];
    
    
    return indexPath;
    
}

-(void)connectTimeOut{

    if (alertView!=NULL && !alertView.isHidden) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;
        
        if (currentPeripheral &&  currentPeripheral.isConnected) {
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"连接超时,请确认锁开启已进入管理员模式。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }
    
}


-(void)cancelAddLockGuider1AlertView
{
    
    [self cancelAlert];
}

-(void) markConnecting:(int)index; {
    
	[tableViewCustom reloadData];
}

-(void) setCustomActivityText:(NSString*) text{
    
	customActivityText = text;
	[tableViewCustom reloadData];
}



-(void)willPresentAlertView:(UIAlertView *)alertViewT{
    
    if (alertViewT.cancelButtonIndex == -1) {
        
        UIActivityIndicatorView* a = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [a setCenter:CGPointMake(alertViewT.bounds.size.width/2, alertViewT.bounds.size.height-40.0f)];
        [a startAnimating];
        [alertViewT addSubview:a];
    }
    
}

//指令功能相关回调
-(void)gotLockVersion:(int)version
{
    
    [AddLockGuider1ViewController setVersion:version];
    
}
-(void)addAdminSuccess_password:(NSString*)password key:(NSString*)key aesKey:(NSData*)aesKeyData version:(NSString*)versionStr mac:(NSString*)mac
{
    
    //name 没有用
    
//    keyAdded.mac = mac;
    keyAdded.lockmac = mac;
    keyAdded.isAdmin = YES;
    keyAdded.password = password;
    keyAdded.key = key;
    keyAdded.aseKey = aesKeyData;
    keyAdded.version = versionStr;
    
    [[DBHelper sharedInstance]saveKey:keyAdded];

    
//    NSLog(@"管理员的aes key");
//    [XYCUtils printByteByByte:keyAdded.aseKey.bytes withLength:16];
    
    //网络数据
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    __block int ret ;
    
    dispatch_async(queue, ^(void){
        
        dispatch_sync(queue, ^(void){
            
            
            NSString * openid =delegate.s.openID;
            NSString * accessToken =delegate.s.accessToken;
            
            ret = [RequestService bindLock:keyAdded accessToken:accessToken clientId:kScienerAppkey protocol_type:@"4" protocol_version:@"1" scene:@"1" group_id:@"1" org_id:@"1"];
            
            if (ret==0) {
                
                Key * key = [[DBHelper sharedInstance]fetchKeyWithLockName:keyAdded.lockName];
                
                key.kid = keyAdded.kid;
                
                key.roomid = keyAdded.roomid;
                
                [[DBHelper sharedInstance]update];
                
            }
            
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            
            NSLog(@"ret:%i",ret);
            
        });
    });




    //页面跳转
    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        
        [self cancelAddLockGuider1AlertView];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    });

}

-(void)scienerError:(ScienerError)error
{
    NSLog(@"错误信息:%i",error);

    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        
        [self cancelAddLockGuider1AlertView];
        
        UIAlertView *alertTMP = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"添加管理员失败，错误码，请查看log。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertTMP show];
        
        
    });
    
}

-(void)calibationTimeSuccess
{

    NSLog(@"开门成功");
    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        
        UIAlertView *alertTMP = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"校准时间成功。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertTMP show];
        
        
    });
}

-(void)unlockSuccess
{

    NSLog(@"开门成功");
    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        
        UIAlertView *alertTMP = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"开门成功。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertTMP show];
        
    });

}

-(void)setAdminKeyboardPasswordSuccess
{

    NSLog(@"设置键盘密码成功");
    dispatch_sync(dispatch_get_main_queue(), ^(void){

        [self cancelAlert];
        
        UIAlertView *alertTMP = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"设置管理员键盘密码成功。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertTMP show];
        
        
    });

}

//蓝牙搜索，连接相关回调
-(void)peripheralFound:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary*)advertisementData
{
    NSString *advName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if (!(advName && advName.length>0)) {
        
        return;
        
    }
    
    NSLog(@"peripheralFound:%@,name:%@,advname:%@",peripheral.name,lockName,[advertisementData objectForKey:@"kCBAdvDataLocalName"]);
    
    
    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        if (peripheral.name && peripheral.name.length>0) {
            
            
            BOOL contain = NO;
            
            for (NSDictionary * dictionary in peripherals) {
                
                CBPeripheral * peripheralTmp = [dictionary valueForKey:@"peripheral"];
                if ([peripheralTmp.name isEqualToString:peripheral.name]) {
                    
                    contain = YES;
                    break;
                    
                }
            }
            
            if (!contain) {
                
                NSDictionary * dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:peripheral,advertisementData, nil] forKeys:[NSArray arrayWithObjects:@"peripheral" , @"advertisementdata", nil]];
                [peripherals addObject:dictionary];
                [tableViewCustom reloadData];
                
            }
            
        }
        
    });
    

}

-(void)setConnect:(CBPeripheral *)peripheral lockName:(NSString*)lockName
{
    
    NSLog(@"连接上lock:%@ , lockname:%@",peripheral.name,lockName);
    
    
    keyAdded = [[KeyModel alloc]init];
    
    keyAdded.lockName = lockName;
    keyAdded.doorName = lockName;
    
    [delegate.s addAdmin_advertisementData:currentAdvData];
    
}

- (void) setDisconnect:(NSString*)lockName
{
    
    dispatch_sync(dispatch_get_main_queue(), ^(void){
        
        [delegate.s scan];//重新开始搜索蓝牙
        
        [self cancelAlert];
        
        [tableViewCustom reloadData];
        
        [self searchAction];
        
    });
    
}


@end
