//
//  UserManageViewController.h
//  BTstackCocoa
//
//  Created by wan on 13-3-6.
//
//

#import <UIKit/UIKit.h>
#import "Key.h"

@interface UserManageViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    
    IBOutlet UILabel * label_no_user;
    IBOutlet UITableView *customTableView;
    IBOutlet UIActivityIndicatorView *aiv;

    NSMutableArray *users;
    UIAlertView *alertView;
    
}

@property (nonatomic, retain) Key* currentKey;


-(void)gotUsers:(NSMutableArray*)usersGot success:(BOOL)success isFromNet:(BOOL)isFromNet;


-(void)showAlert;
-(void)cancelAlert;




@end