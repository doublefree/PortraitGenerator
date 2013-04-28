//
//  PartsCellView.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/23/13.
//
//

#import "PartsCategoryCellView.h"
#import "AppDelegate.h"

@interface PartsCategoryCellView()
@property (retain, nonatomic) NSString* category;
@end

@implementation PartsCategoryCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ;
    }
    return self;
}

- (void)registerNotification {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(partsCategorySelected:) name:NOTIFICATION_PARTS_CATEGORY_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(selectedCategoryChanged:) name:NOTIFICATION_SELECTED_CATEGORY_CHANGED object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)set:(NSString*)category
{
    self.category = category;
    [self.button setTitle:category forState:UIControlStateNormal];
}
- (IBAction)buttonPushed:(id)sender {
    [self buttonToSelected];
    [self notifyToOtherCells];
}

- (void)buttonToSelected
{
    [[self.button layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.button layer] setBorderWidth:3.0f];
}

- (void)notifyToOtherCells
{
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:self.category forKey:@"category"];
    NSNotification* nc = [NSNotification notificationWithName:NOTIFICATION_PARTS_CATEGORY_BUTTON_PUSHED object:self userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotification:nc];
}

- (void)selectedCategoryChanged:(NSNotification*)center
{
    NSString* category = [[center userInfo] objectForKey:@"category"];
    if ([category length] != 0 && [self.category isEqualToString:category]) {
        [self buttonToSelected];
        [self notifyToOtherCells];
    }
}

- (void)partsCategorySelected:(NSNotification*)center
{
    NSString* category = [[center userInfo] objectForKey:@"category"];
    if ([category length] != 0 && ![self.category isEqualToString:category]) {
        [[self.button layer] setBorderWidth:0.0f];
    }
}

- (void)dealloc {
    [super dealloc];
}
@end
