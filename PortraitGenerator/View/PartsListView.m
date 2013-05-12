//
//  PartsListView.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/24/13.
//
//

#import "PartsListView.h"
#import "PartsCellView.h"
#import "Parts.h"

@interface PartsListView()
- (IBAction)closeButtonPushed:(id)sender;
@end

@implementation PartsListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ;
    }
    return self;
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Parts partsForCategory:self.category] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartsCellView *cell = nil;
    if (cell == nil) {
        UIViewController* controller;
        controller = [[UIViewController alloc] initWithNibName:@"PartsCellView" bundle:nil];
        cell = (PartsCellView*)controller.view;
        NSArray* allKeys = [[[Parts partsForCategory:self.category] allKeys] sortedArrayUsingComparator:^(id obj1, id obj2){return [obj1 compare:obj2];}];
        NSString* key = [allKeys objectAtIndex:indexPath.row];
        NSDictionary* dictionary = [Parts partsForCategory:self.category];
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [data setDictionary:[dictionary objectForKey:key]];
        [data setObject:self.category forKey:@"category"];
        [cell setData:data];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CATEGORY_CELL_HEIGHT;
}

- (void)dealloc {
    [_tableView release];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [super dealloc];
}

- (void) categorySelected:(NSNotification*)center{
    NSString* category = [[center userInfo] objectForKey:@"category"];
    if ([category length] != 0 && ![category isEqualToString:self.category]) {
        [self removeFromSuperview];
    }
}

- (void) respondToDeleteView:(NSNotification*)center{
    [self removeFromSuperview];
}

- (IBAction)closeButtonPushed:(id)sender {
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:self.category forKey:@"category"];
    NSNotification* ncDel = [NSNotification notificationWithName:NOTIFICATION_PARTS_DELETE_BUTTON_PUSHED object:self userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotification:ncDel];
}
@end
