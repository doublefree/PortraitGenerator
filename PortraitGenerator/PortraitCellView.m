//
//  PortraitCellView.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import "PortraitCellView.h"
int const CELL_HEIGHT = 64.0f;

@implementation PortraitCellView

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

+ (float)cellHeight {
    return CELL_HEIGHT;
}
- (void)dealloc {
    [_nameLabel release];
    [_nameLabel release];
    [super dealloc];
}
@end
