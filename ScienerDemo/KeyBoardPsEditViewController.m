//
//  KeyBoardPsEditViewController.m
//  sciener
//
//  Created by 谢元潮 on 15/3/27.
//
//

#import "KeyBoardPsEditViewController.h"
#import "SendKeyCell.h"
#import "ProgressHUD.h"
#import "XYCUtils.h"
#import "DBHelper.h"
#import "AppDelegate.h"

@interface KeyBoardPsEditViewController ()
{
    
    UIAlertView * alertView;
    
    IBOutlet UISegmentedControl * segmentButton;
    
    IBOutlet UIView * mProgressBg;
    
    
    
}

-(IBAction)segmentedChanged:(id)sender;



@end

//BOOL isAddNewKbPwd = FALSE;

@implementation KeyBoardPsEditViewController

@synthesize ps,isSendNewKeyboardPs,psType,isLocal;

#define TAG_TEXT_FIELD_RECEIVER 1
#define TAG_TEXT_FIELD_TIMES    2
#define TAG_TEXT_FIELD_PASSWORD 3

KeyBoardPsEditViewController * instanceKbEdit=nil;

+(KeyBoardPsEditViewController *) sharedInstance {
    
    return instanceKbEdit;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
//        psType = KEYBOARD_PS_TYPE_ADMIN;
        
        psType = KEYBOARD_PS_TYPE_NORMAL_ALL_DATE;
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    instanceKbEdit = self;
    
//    isAddNewKbPwd = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    [mProgressBg setHidden:YES];
    if (ps) {
        
        self.title = @"更新键盘密码";
        
    }else{
        
        ps = [[KeyboardPs alloc]init];
        ps.startDate = [NSDate date];
        ps.endDate = [NSDate date];
        self.title = @"新增键盘密码";
        ps.type = psType;
    }
    
    switch (psType) {
//        case KEYBOARD_PS_TYPE_ADMIN:
//            [segmentButton setSelectedSegmentIndex:0];
//            break;
        case KEYBOARD_PS_TYPE_NORMAL_ALL_DATE:
            [segmentButton setSelectedSegmentIndex:0];
            break;
        case KEYBOARD_PS_TYPE_LIMITED_DATE:
            [segmentButton setSelectedSegmentIndex:1];
            break;
        case KEYBOARD_PS_TYPE_LIMITED_TIMES:
            [segmentButton setSelectedSegmentIndex:2];
            break;
            
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addNewPsSuccess:(BOOL)success errorCode:(int)errorCode
{

    
    [ProgressHUD dismiss];
    
    [mProgressBg setHidden:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
    
//    isAddNewKbPwd = NO;
    
    if (success) {

        //成功
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"添加键盘密码成功"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil)
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }else{
    
        //失败
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"添加键盘密码失败"
                                                        message:[NSString stringWithFormat:@"errorCode:%i",errorCode]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil)
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    switch (psType) {
        case KEYBOARD_PS_TYPE_LIMITED_DATE:
            //时效密码
            return 3;
            break;
        case KEYBOARD_PS_TYPE_NORMAL_ALL_DATE:
            //永久密码
            return 1;
            break;
        case KEYBOARD_PS_TYPE_LIMITED_TIMES:
            //次数密码
            return 2;
            break;
//        case KEYBOARD_PS_TYPE_ADMIN:
//            //次数密码
//            return 1;
//            break;
            
        default:
            break;
            
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
//            if (psType == KEYBOARD_PS_TYPE_ADMIN) {
            
                return 1;
//            }
//            return 2;
            
            
            break;
            
        case 1:
            if (psType == KEYBOARD_PS_TYPE_LIMITED_DATE) {
             
                //时效密码
                return 2;
            }else{
            
                //次数密码
                return 1;
            }
            break;
            
        case 2:
            if (psType == KEYBOARD_PS_TYPE_LIMITED_DATE) {
                
                //时效密码
                return 2;
            }
            break;
            
        default:
            break;
    }
    
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            
//            if (psType == KEYBOARD_PS_TYPE_ADMIN) {
            
                return nil;
//            }else{
//                
//                return NSLocalizedString(@"words_receiver", nil);
//            }
            
            break;
        case 1:
            
            if (psType == KEYBOARD_PS_TYPE_LIMITED_DATE) {
                
                return NSLocalizedString(@"words_start_time", nil);
            }else{
                
                return @"可使用次数";
            }
            
            break;
        case 2:
            
            if (psType == KEYBOARD_PS_TYPE_LIMITED_DATE) {
                
                return NSLocalizedString(@"words_end_time", nil);
            }
            
            break;
            
        default:
            break;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"SendKeyCell";
    SendKeyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SendKeyCell"
                                              owner:self
                                            options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    cell.text_field.delegate = self;
    
    switch (indexPath.section) {
        case 0:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    
//                    if (psType == KEYBOARD_PS_TYPE_ADMIN) {
                    
                        //密码内容
                        cell.text_field.tag = TAG_TEXT_FIELD_PASSWORD;
                        
                        cell.text_field.placeholder = @"请输入键盘密码";
                        cell.text_field.text = ps.keyboardPs;
                        
                        [cell.text_label removeFromSuperview];
                        
//                    }else{
//                        
//                        //接受人名称
//                        cell.text_field.tag = TAG_TEXT_FIELD_RECEIVER;
//                        
//                        cell.text_field.placeholder = @"请输入对方的科技侠账号，或者手机号码";
//                        cell.text_field.text = ps.userName;
//                        
////                        if (isSendNewKeyboardPs) {
////                            
////                            [cell.text_field setEnabled:YES];
////                        }else{
////                            
////                            [cell.text_field setEnabled:NO];
////                        }
//                        
//                        [cell.text_label removeFromSuperview];
//                        
//                    }
                    
                    break;
                }
                case 1:
                {
                    //密码内容
                    cell.text_field.tag = TAG_TEXT_FIELD_PASSWORD;
                    
                    cell.text_field.placeholder = @"请输入键盘密码";
                    cell.text_field.text = ps.keyboardPs;
                    
                    [cell.text_label removeFromSuperview];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            if (psType == KEYBOARD_PS_TYPE_LIMITED_DATE) {
                
                switch (indexPath.row) {
                    case 0:
                        
                        [cell.text_field removeFromSuperview];
                        cell.text_label.text = [XYCUtils formateDate:ps.startDate format:[NSString stringWithFormat:@"yyyy%@MM%@dd%@",NSLocalizedString(@"words_year", nil),NSLocalizedString(@"words_month", nil),NSLocalizedString(@"words_day", nil)]];
                        
                        break;
                    case 1:
                        [cell.text_field removeFromSuperview];
                        
                        cell.text_label.text = [XYCUtils formateDate:ps.startDate format:[NSString stringWithFormat:@"HH%@mm%@",NSLocalizedString(@"words_hour", nil),NSLocalizedString(@"words_minute", nil)]];
                        break;
                    default:
                        break;
                }
            }else{
                
                //密码使用次数
                cell.text_field.tag = TAG_TEXT_FIELD_TIMES;
                cell.text_field.placeholder = @"请输入密码使用次数";
                
                [cell.text_label removeFromSuperview];
                
                break;
            }
            
            
            break;
        }
            
        case 2:
        {
            
            switch (indexPath.row) {
                case 0:
                    
                    [cell.text_field removeFromSuperview];
                    cell.text_label.text = [XYCUtils formateDate:ps.endDate format:[NSString stringWithFormat:@"yyyy%@MM%@dd%@",NSLocalizedString(@"words_year", nil),NSLocalizedString(@"words_month", nil),NSLocalizedString(@"words_day", nil)]];
                    
                    break;
                case 1:
                    
                    [cell.text_field removeFromSuperview];
                    cell.text_label.text = [XYCUtils formateDate:ps.endDate format:[NSString stringWithFormat:@"HH%@mm%@",NSLocalizedString(@"words_hour", nil),NSLocalizedString(@"words_minute", nil)]];
                    
                    break;
                default:
                    break;
            }
            
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
            
        case 1:
        {
            
            if (psType == KEYBOARD_PS_TYPE_LIMITED_DATE) {
                
                switch (indexPath.row) {
                        
                    case 0:
                    {
                        
                        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
                        if (order == NSOrderedSame || order == NSOrderedDescending) {
                            
                            NSString *title = NSLocalizedString(@"请选择时间", nil);
                            NSString *message = NSLocalizedString(@"\n\n\n\n\n\n\n\n\n\n\n\n", nil);
                            NSString *cancelButtonTitle = NSLocalizedString(@"words_cancel", nil);
                            NSString *otherButtonTitle = NSLocalizedString(@"words_sure_ok", nil);
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
                            
                            // Create the actions.
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
                            }];
                            
                            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                                
                                
                                UIDatePicker *datePicker = (UIDatePicker*)[alertController.view viewWithTag:10];
                                
                                NSString *dateStr = [XYCUtils formateDate:datePicker.date format:@"yyyyMMdd"];
                                NSString *time = @"0000";
                                if (ps.startDate) {
                                    
                                    time = [XYCUtils formateDate:ps.startDate format:@"HHmm"];
                                    
                                }
                                
                                ps.startDate = [XYCUtils formateDateFromStringToDate:[NSString stringWithFormat:@"%@%@",dateStr,time] format:@"yyyyMMddHHmm"];
                                
                                [mTableView reloadData];
                                
                            }];
                            
                            // Add the actions.
                            [alertController addAction:cancelAction];
                            [alertController addAction:otherAction];
                            
                            
                            UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;
                            [datePicker setDatePickerMode:UIDatePickerModeDate];
                            datePicker.frame = CGRectMake(0, 40, alertController.view.frame.size.width-20, datePicker.frame.size.height);
                            datePicker.tag = 10;
                            
                            NSDateComponents *comps = [[NSDateComponents alloc]init];
                            [comps setMonth:12];
                            [comps setDay:31];
                            [comps setYear:2099];
                            NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                            NSDate *maxDate = [calendar dateFromComponents:comps];
                            [datePicker setMaximumDate:maxDate];
                            
                            
                            [alertController.view addSubview:datePicker];
                            
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                            
                        }else{
                            
                            UIActionSheet * startsheet = [[UIActionSheet alloc] initWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                                     delegate:self
                                                                            cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                                       destructiveButtonTitle:nil
                                                                            otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),
                                                          nil];
                            //                    startsheet.actionSheetStyle = self.navigationController.navigationBar.barStyle;
                            [startsheet showInView:self.view];
                            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                            [datePicker setDatePickerMode:UIDatePickerModeDate];
                            datePicker.frame = CGRectMake(0, 40, datePicker.frame.size.width, datePicker.frame.size.height);
                            datePicker.tag = 10;
                            
                            NSDateComponents *comps = [[NSDateComponents alloc]init];
                            [comps setMonth:12];
                            [comps setDay:31];
                            [comps setYear:2099];
                            NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                            NSDate *maxDate = [calendar dateFromComponents:comps];
                            [datePicker setMaximumDate:maxDate];
                            
                            
                            startsheet.tag=100;
                            [startsheet addSubview:datePicker];
                        }
                        
                        break;
                    }
                    case 1:
                    {
                        
                        
                        
                        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
                        if (order == NSOrderedSame || order == NSOrderedDescending){
                            
                            NSString *title = NSLocalizedString(@"请选择时间", nil);
                            NSString *message = NSLocalizedString(@"\n\n\n\n\n\n\n\n\n\n\n\n", nil);
                            NSString *cancelButtonTitle = NSLocalizedString(@"words_cancel", nil);
                            NSString *otherButtonTitle = NSLocalizedString(@"words_sure_ok", nil);
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
                            
                            // Create the actions.
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
                            }];
                            
                            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                                
                                
                                UIDatePicker *datePicker = (UIDatePicker*)[alertController.view viewWithTag:11];
                                
                                
                                NSString *dateStr = [XYCUtils formateDate:[NSDate date] format:@"yyyyMMdd"];
                                NSString *time = [XYCUtils formateDate:datePicker.date format:@"HHmm"];
                                if (ps.startDate) {
                                    
                                    dateStr = [XYCUtils formateDate:ps.startDate format:@"yyyyMMdd"];
                                    
                                }
                                
                                ps.startDate = [XYCUtils formateDateFromStringToDate:[NSString stringWithFormat:@"%@%@",dateStr,time] format:@"yyyyMMddHHmm"];
                                
                                
                                
                                [mTableView reloadData];
                                
                            }];
                            
                            // Add the actions.
                            [alertController addAction:cancelAction];
                            [alertController addAction:otherAction];
                            
                            
                            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                            [datePicker setDatePickerMode:UIDatePickerModeTime];
                            datePicker.frame = CGRectMake(0, 40, alertController.view.frame.size.width-20, datePicker.frame.size.height);
                            datePicker.tag = 11;
                            
                            NSDateComponents *comps = [[NSDateComponents alloc]init];
                            [comps setMonth:12];
                            [comps setDay:31];
                            [comps setYear:2099];
                            NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                            NSDate *maxDate = [calendar dateFromComponents:comps];
                            [datePicker setMaximumDate:maxDate];
                            
                            
                            [alertController.view addSubview:datePicker];
                            
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                            
                        }else{
                            
                            UIActionSheet * startsheet = [[UIActionSheet alloc] initWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                                     delegate:self
                                                                            cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                                       destructiveButtonTitle:nil
                                                                            otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),
                                                          nil];
                            //                    startsheet.actionSheetStyle = self.navigationController.navigationBar.barStyle;
                            [startsheet showInView:self.view];
                            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                            [datePicker setDatePickerMode:UIDatePickerModeTime];
                            datePicker.frame = CGRectMake(0, 40, datePicker.frame.size.width, datePicker.frame.size.height);
                            datePicker.tag = 11;
                            startsheet.tag=110;
                            [startsheet addSubview:datePicker];
                            
                        }
                        
                        
                        break;
                    }
                        
                    default:
                        break;
                }
                
            }
            break;
        }
        case 2:
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    
                    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
                    if (order == NSOrderedSame || order == NSOrderedDescending){
                        
                        NSString *title = NSLocalizedString(@"请选择时间", nil);
                        NSString *message = NSLocalizedString(@"\n\n\n\n\n\n\n\n\n\n\n\n", nil);
                        NSString *cancelButtonTitle = NSLocalizedString(@"words_cancel", nil);
                        NSString *otherButtonTitle = NSLocalizedString(@"words_sure_ok", nil);
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
                        
                        // Create the actions.
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
                        }];
                        
                        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                            
                            
                            UIDatePicker *datePicker = (UIDatePicker*)[alertController.view viewWithTag:20];
                            
                            
                            NSString *dateStr = [XYCUtils formateDate:datePicker.date format:@"yyyyMMdd"];
                            NSString *time = @"0000";
                            if (ps.endDate) {
                                
                                time = [XYCUtils formateDate:ps.endDate format:@"HHmm"];
                                
                            }
                            
                            ps.endDate = [XYCUtils formateDateFromStringToDate:[NSString stringWithFormat:@"%@%@",dateStr,time] format:@"yyyyMMddHHmm"];
                            
                            [mTableView reloadData];
                            
                        }];
                        
                        // Add the actions.
                        [alertController addAction:cancelAction];
                        [alertController addAction:otherAction];
                        
                        
                        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                        [datePicker setDatePickerMode:UIDatePickerModeDate];
                        datePicker.frame = CGRectMake(0, 40, alertController.view.frame.size.width-20, datePicker.frame.size.height);
                        datePicker.tag = 20;
                        
                        NSDateComponents *comps = [[NSDateComponents alloc]init];
                        [comps setMonth:12];
                        [comps setDay:31];
                        [comps setYear:2099];
                        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                        NSDate *maxDate = [calendar dateFromComponents:comps];
                        [datePicker setMaximumDate:maxDate];
                        
                        
                        [alertController.view addSubview:datePicker];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        
                    }else{
                        
                        UIActionSheet * startsheet = [[UIActionSheet alloc] initWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                                 delegate:self
                                                                        cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                                   destructiveButtonTitle:nil
                                                                        otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),
                                                      nil];
                        [startsheet showInView:self.view];
                        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                        [datePicker setDatePickerMode:UIDatePickerModeDate];
                        datePicker.frame = CGRectMake(0, 40, datePicker.frame.size.width, datePicker.frame.size.height);
                        datePicker.tag = 20;
                        
                        
                        NSDateComponents *comps = [[NSDateComponents alloc]init];
                        [comps setMonth:12];
                        [comps setDay:31];
                        [comps setYear:2099];
                        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                        NSDate *maxDate = [calendar dateFromComponents:comps];
                        [datePicker setMaximumDate:maxDate];
                        
                        
                        startsheet.tag=200;
                        [startsheet addSubview:datePicker];
                        
                    }
                    
                    
                    break;
                }
                case 1:
                {
                    
                    
                    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
                    if (order == NSOrderedSame || order == NSOrderedDescending){
                        
                        NSString *title = NSLocalizedString(@"请选择时间", nil);
                        NSString *message = NSLocalizedString(@"\n\n\n\n\n\n\n\n\n\n\n\n", nil);
                        NSString *cancelButtonTitle = NSLocalizedString(@"words_cancel", nil);
                        NSString *otherButtonTitle = NSLocalizedString(@"words_sure_ok", nil);
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
                        
                        // Create the actions.
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
                        }];
                        
                        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                            
                            
                            UIDatePicker *datePicker = (UIDatePicker*)[alertController.view viewWithTag:21];
                            
                            
                            NSString *dateStr = [XYCUtils formateDate:[NSDate date] format:@"yyyyMMdd"];
                            NSString *time = [XYCUtils formateDate:datePicker.date format:@"HHmm"];
                            if (ps.endDate) {
                                
                                dateStr = [XYCUtils formateDate:ps.endDate format:@"yyyyMMdd"];
                                
                            }
                            
                            ps.endDate = [XYCUtils formateDateFromStringToDate:[NSString stringWithFormat:@"%@%@",dateStr,time] format:@"yyyyMMddHHmm"];
                            
                            [mTableView reloadData];
                            
                        }];
                        
                        // Add the actions.
                        [alertController addAction:cancelAction];
                        [alertController addAction:otherAction];
                        
                        
                        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                        [datePicker setDatePickerMode:UIDatePickerModeTime];
                        datePicker.frame = CGRectMake(0, 40, alertController.view.frame.size.width-20, datePicker.frame.size.height);
                        datePicker.tag = 21;
                        
                        NSDateComponents *comps = [[NSDateComponents alloc]init];
                        [comps setMonth:12];
                        [comps setDay:31];
                        [comps setYear:2099];
                        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                        NSDate *maxDate = [calendar dateFromComponents:comps];
                        [datePicker setMaximumDate:maxDate];
                        
                        
                        [alertController.view addSubview:datePicker];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        
                    }else{
                        
                        UIActionSheet * startsheet = [[UIActionSheet alloc] initWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                                 delegate:self
                                                                        cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                                   destructiveButtonTitle:nil
                                                                        otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),
                                                      nil];
                        [startsheet showInView:self.view];
                        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                        [datePicker setDatePickerMode:UIDatePickerModeTime];
                        datePicker.frame = CGRectMake(0, 40, datePicker.frame.size.width, datePicker.frame.size.height);
                        datePicker.tag = 21;
                        startsheet.tag=210;
                        [startsheet addSubview:datePicker];
                        
                    }
                    
                    
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (actionSheet.tag) {
        case 100:
        {
            
            //起始时间日期
            
            UIDatePicker *datePicker = (UIDatePicker*)[actionSheet viewWithTag:10];
            
            NSString *dateStr = [XYCUtils formateDate:datePicker.date format:@"yyyyMMdd"];
            NSString *time = @"0000";
            if (ps.startDate) {
                
                time = [XYCUtils formateDate:ps.startDate format:@"HHmm"];
                
            }
            
            ps.startDate = [XYCUtils formateDateFromStringToDate:[NSString stringWithFormat:@"%@%@",dateStr,time] format:@"yyyyMMddHHmm"];
            
            break;
        }
        case 110:
        {
            
            //起始时间time
            
            UIDatePicker *datePicker = (UIDatePicker*)[actionSheet viewWithTag:11];
            NSString *dateStr = [XYCUtils formateDate:[NSDate date] format:@"yyyyMMdd"];
            NSString *time = [XYCUtils formateDate:datePicker.date format:@"HHmm"];
            if (ps.startDate) {
                
                dateStr = [XYCUtils formateDate:ps.startDate format:@"yyyyMMdd"];
                
            }
            
            ps.startDate = [XYCUtils formateDateFromStringToDate:[NSString stringWithFormat:@"%@%@",dateStr,time] format:@"yyyyMMddHHmm"];
            
            break;
        }
        case 200:
        {
            
            //截止时间日期
            
            UIDatePicker *datePicker = (UIDatePicker*)[actionSheet viewWithTag:20];
            
            NSString *dateStr = [XYCUtils formateDate:datePicker.date format:@"yyyyMMdd"];
            NSString *time = @"0000";
            if (ps.endDate) {
                
                time = [XYCUtils formateDate:ps.endDate format:@"HHmm"];
                
            }
            
            ps.endDate = [XYCUtils formateDateFromStringToDate:[NSString stringWithFormat:@"%@%@",dateStr,time] format:@"yyyyMMddHHmm"];
            
            
            break;
        }
        case 210:
        {
            
            //截止时间time
            
            UIDatePicker *datePicker = (UIDatePicker*)[actionSheet viewWithTag:21];
            
            NSString *dateStr = [XYCUtils formateDate:[NSDate date] format:@"yyyyMMdd"];
            NSString *time = [XYCUtils formateDate:datePicker.date format:@"HHmm"];
            if (ps.endDate) {
                
                dateStr = [XYCUtils formateDate:ps.endDate format:@"yyyyMMdd"];
                
            }
            
            ps.endDate = [XYCUtils formateDateFromStringToDate:[NSString stringWithFormat:@"%@%@",dateStr,time] format:@"yyyyMMddHHmm"];
            
            break;
        }
            
        default:
            break;
    }
    
    [mTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    
    switch (textField.tag) {
            
        case TAG_TEXT_FIELD_RECEIVER:
            
            ps.userName = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            break;
        case TAG_TEXT_FIELD_PASSWORD:
            
            ps.keyboardPs = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            break;
        case TAG_TEXT_FIELD_TIMES:
            
            ps.times = [textField.text stringByReplacingCharactersInRange:range withString:string].intValue;
            
            break;
        default:
            
            break;
    }
    
    return YES;
    
}

-(void)cancelAlert
{
    
    [mProgressBg setHidden:YES];
    [ProgressHUD dismiss];
    
}

-(void)showAlert
{
    
    [mProgressBg setHidden:NO];
    [ProgressHUD show:NSLocalizedString(@"words_wait_please", "moment please...")];
    
}


-(IBAction)buttonClicked
{
    
//    if (isSendNewKeyboardPs) {
    
        //发送新的键盘密码
        
        //校验密码
        if ([XYCUtils checkNokeyPassword:ps.keyboardPs ok4Zero:YES]) {
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"alert_msg_error_nokeypassword_0_len", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
    
        //校验用户名
//        if (psType != KEYBOARD_PS_TYPE_ADMIN) {
//            
//            if (![XYCUtils checkRegistUserName:ps.userName]) {
//                
//                
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:@"请输入正确的用户名（或者手机号）" delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
//                [alert show];
//                
//                return;
//            }
//            
//        }
    
    switch (psType) {
        case KEYBOARD_PS_TYPE_LIMITED_DATE:
        {
            //校验时间
            
            if (ps.endDate.timeIntervalSince1970<=ps.startDate.timeIntervalSince1970) {
                
                //结束时间小于等于开始时间
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:@"结束时间必须晚与开始时间。" delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                [alert show];
                
                return;

            }
            
            break;
        }
        case KEYBOARD_PS_TYPE_LIMITED_TIMES:
        {
            //校验次数
            if (ps.times<=0) {
                
                //次数小于等于0
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:@"密码的使用次数必须大于0" delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                [alert show];
                
                return;
                
            }
            break;
        }
        
            
        default:
            break;
    }
    
    
        
    [self showAlert];
    
    
    
    //本地设置
    if (isLocal) {
        
        //本地添加]
        
        [self performSelector:@selector(connectTimeOut) withObject:nil afterDelay:5];
        
        extern Key* selectedKey;
        NSLog(@"设置键盘密码 verson:%@,ps type:%i",selectedKey.version,ps.type);
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).s setUserKeyBoardPassword:ps.keyboardPs key:selectedKey.key password:selectedKey.password psType:ps.type startDate:ps.startDate endDate:ps.endDate times:ps.times aesKey:selectedKey.aseKey version:selectedKey.version unlockFlag:selectedKey.unlockFlag];
        
        return;
        
    }
    
    
    
//    //网络设置
//        __block int ret ;
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//        dispatch_async(queue, ^(void){
//            
//            dispatch_sync(queue, ^(void){
//                
//                //TODO
//                extern Key* selectedKey;
//                if (psType == KEYBOARD_PS_TYPE_ADMIN) {
//                    
//                    ret = [RequestService SetAdminKeyboardPsWithUid:[SettingHelper getUID] password:@"1234567" lockId:[NSString stringWithFormat:@"%i",selectedKey.roomId] keyboardPs:ps.keyboardPs key:[XYCUtils DecodeScienerPS:selectedKey.aesKey]];
//                    
//                }else{
//                    
//                    ret = [RequestService SetKeyboardPsWithUid:[SettingHelper getUID] password:@"1234567" lockId:[NSString stringWithFormat:@"%i",selectedKey.roomId] type:[NSString stringWithFormat:@"%i",psType] keyboardPs:ps.keyboardPs startDate:ps.startDate endDate:ps.endDate times:[NSString stringWithFormat:@"%i",ps.times] key:[XYCUtils DecodeScienerPS:selectedKey.aesKey] userName:ps.userName];
//                    
//                }
//               
//            });
//            
//            dispatch_sync(dispatch_get_main_queue(), ^(void){
//                
//                [self cancelAlert];
//                
//                if (ret == NET_REQUEST_SUCCESS) {
//                    
//                    //成功
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"设置键盘密码成功"
//                                                                    message:nil
//                                                                   delegate:self
//                                                          cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil)
//                                                          otherButtonTitles:nil];
//                    
//                    [alert show];
//                    
//                }else if(ret == NET_REQUEST_ERROR_keyboard_password_exist){
//                    //该锁中已经存在该键盘密
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"该锁中已经存在该键盘密"
//                                                                    message:nil
//                                                                   delegate:self
//                                                          cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil)
//                                                          otherButtonTitles:nil];
//                    
//                    [alert show];
//                    
//                }else if(ret == NET_REQUEST_ERROR_invalid_keyboard_password){
//                
//                    //键盘密码信息不正确,可能是 roomId,uid 或键盘密码错误
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"键盘密码信息不正确,可能是 roomId,uid 或键盘密码错误"
//                                                                    message:nil
//                                                                   delegate:self
//                                                          cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil)
//                                                          otherButtonTitles:nil];
//                    
//                    [alert show];
//                    
//                }else if(ret == NET_REQUEST_ERROR_plug_off_line){
//                
//                    //没有找到对应的插座 channel
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"没有找到对应的插座 channel"
//                                                                    message:nil
//                                                                   delegate:self
//                                                          cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil)
//                                                          otherButtonTitles:nil];
//                    [alert show];
//                    
//                }else{
//                    
//                    //失败
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"设置键盘密码失败"
//                                                                    message:nil
//                                                                   delegate:self
//                                                          cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil)
//                                                          otherButtonTitles:nil];
//                    
//                    [alert show];
//                    
//                }
//                
//            });
//        });
////    }else{
////        
////        //更新键盘密码时间
////        NSLog(@"更新键盘密码时间");
////        
////    }
    
    
}

-(void)connectTimeOut{
    
    [self cancelAlert];
    
    
}

-(IBAction)segmentedChanged:(id)sender{
    
    NSInteger Index = ((UISegmentedControl*)sender).selectedSegmentIndex;
    
    
    switch (Index) {
//        case 0:
//            psType = KEYBOARD_PS_TYPE_ADMIN;
//            
//            break;
        case 0:
            psType = KEYBOARD_PS_TYPE_NORMAL_ALL_DATE;
            break;
        case 1:
            psType = KEYBOARD_PS_TYPE_LIMITED_DATE;
            break;
        case 2:
            psType = KEYBOARD_PS_TYPE_LIMITED_TIMES;
            break;
            
        default:
            break;
    }
    
    NSLog(@"segment index:%i,ps type:%i",Index,psType);
    
    ps.type = psType;
    [mTableView reloadData];
    
}



@end
