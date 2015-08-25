//
//  SendKeyCell.h
//  Sciener
//
//  Created by 谢元潮 on 13-10-28.
//
//

#import <UIKit/UIKit.h>

@interface SendKeyCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,retain) IBOutlet UITextField *text_field;
@property(nonatomic,retain) IBOutlet UILabel *text_label;
@property(nonatomic,retain) IBOutlet UILabel *text_label_left;
//@property(nonatomic,retain) IBOutlet MBContactPicker *name;
//@property (nonatomic, retain) IBOutlet NSLayoutConstraint *contactPickerViewHeightConstraint;

@end
