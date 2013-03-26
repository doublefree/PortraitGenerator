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
        [cell setData:[[Parts partsForCategory:self.category] objectForKey:key]];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
