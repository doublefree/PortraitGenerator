//
//  PortraitCellView.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import "PortraitCellView.h"
int const CELL_HEIGHT = 64.0f;

@interface PortraitCellView()
- (IBAction)deleteButtonPushed:(id)sender;
- (IBAction)loadButtonPushed:(id)sender;
@end

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
    [super setSelected:NO animated:animated];
}

+ (float)cellHeight {
    return CELL_HEIGHT;
}
- (void)dealloc {
    [_nameLabel release];
    [_nameLabel release];
    [_image release];
    [super dealloc];
}
- (IBAction)deleteButtonPushed:(id)sender {
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:self.nameLabel.text forKey:@"name"];
    NSNotification* nc = [NSNotification notificationWithName:NOTIFICATION_DELETE_BUTTON_PUSHED object:self userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotification:nc];
}

- (IBAction)loadButtonPushed:(id)sender {
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:self.nameLabel.text forKey:@"name"];
    NSNotification* nc = [NSNotification notificationWithName:NOTIFICATION_LOAD_BUTTON_PUSHED object:self userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotification:nc];
}
@end
