//
//  UnlockRecordCell.m
//  BTstackCocoa
//
//  Created by wan on 13-3-29.
//
//

#import "UnlockRecordCell.h"

@implementation UnlockRecordCell

@synthesize label_date,label_operator,label_unlcok_type;

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
