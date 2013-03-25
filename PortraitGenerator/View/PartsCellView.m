//
//  PartsCellView.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/24/13.
//
//

#import "AppDelegate.h"
#import "PartsCellView.h"

@interface PartsCellView()
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) NSString* parts;
@end

@implementation PartsCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)buttonPushed:(id)sender {
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:self.parts forKey:@"parts"];
    NSNotification* nc = [NSNotification notificationWithName:NOTIFICATION_PARTS_BUTTON_PUSHED object:self userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotification:nc];
}

- (void)setData:(NSString*)parts {
    self.parts = parts;
    [self.button setTitle:parts forState:UIControlStateNormal];
}

- (void)dealloc {
    [_button release];
    [super dealloc];
}
@end