//
//  AboutCell.m
//  BTstackCocoa
//
//  Created by wan on 13-3-13.
//
//

#import "AboutCell.h"

@implementation AboutCell
@synthesize label_left,label_right;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
