//
//  KeyboardPsManageViewController.h
//  sciener
//
//  Created by 谢元潮 on 15/3/27.
//
//

#import <UIKit/UIKit.h>
#import "KeyboardPs.h"
#import "AppDelegate.h"

@interface KeyboardPsManageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    
    IBOutlet UITableView* mTableView;
}

@property(nonatomic) BOOL isLocal;

+(KeyboardPsManageViewController *) sharedInstance;


-(void)getKbPwdFinish:(BOOL)success;

-(void)getKbPwd:(KeyboardPs*)pwd;

-(void)deleteKbPwdSuccess:(BOOL)success;

-(void)getKeyPassword:(KeyboardPsType)type password:(NSString*)password times:(int)times startDate:(NSDate*)startDate endDate:(NSDate*)endDate isLast:(BOOL)isLast;

@end
