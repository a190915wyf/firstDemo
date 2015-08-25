//
//  Tab0ViewCell.m
//  BTstackCocoa
//
//  Created by wan on 13-2-27.
//
//

#import "Tab0ViewCell.h"

@implementation Tab0ViewCell

//@synthesize image;
@synthesize label_key_name,label_user_type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    [super setSelected:selected animated:animated];

}

//-(void)layoutSubviews{
//    
//    CGSize size = [label_key_name.text sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:CGSizeMake(2000, 20000)];
//    
//    if (size.width>180) {
//        //不能太长咯
////        label_key_name.frame = CGRectMake(label_key_name.frame.origin.x, label_key_name.frame.origin.y, 180, label_key_name.frame.size.height);
//        
//        label_new.frame = CGRectMake(180, label_new.frame.origin.y, label_new.frame.size.width, label_new.frame.size.height);
//    }else{
//    
//        label_new.frame = CGRectMake(size.width, label_new.frame.origin.y, label_new.frame.size.width, label_new.frame.size.height);
//    }
//    
////    [super layoutSubviews];
//    
//}

@end
