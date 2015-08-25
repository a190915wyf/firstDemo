//
//  KeyBoardPsEditViewController.h
//  sciener
//
//  Created by 谢元潮 on 15/3/27.
//
//

#import <UIKit/UIKit.h>
#import "KeyboardPs.h"

@interface KeyBoardPsEditViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>
{

    IBOutlet UITableView * mTableView;
    
}

@property(nonatomic,retain) KeyboardPs * ps;
@property(nonatomic) BOOL isSendNewKeyboardPs;
@property(nonatomic) BOOL isLocal;
@property(nonatomic) int psType;

+(KeyBoardPsEditViewController *) sharedInstance;

-(IBAction)buttonClicked;

//本地设置键盘密码成功
-(void)addNewPsSuccess:(BOOL)success errorCode:(int)errorCode;

@end
