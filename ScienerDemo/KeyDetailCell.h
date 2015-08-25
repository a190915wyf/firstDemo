//
//  KeyDetailCell.h
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import <UIKit/UIKit.h>

@interface KeyDetailCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UILabel *label_left;
@property(nonatomic,retain) IBOutlet UILabel *label_right;
@property(nonatomic,retain) IBOutlet UISwitch *switch_right;
@property(nonatomic,retain) IBOutlet UIImageView *img_right_top;
@property(nonatomic,retain) IBOutlet UISlider *slider;

@end
