//
//  PartsTableDataDelegate.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/23/13.
//
//

#import "PartsTableDataDelegate.h"
#import "PartsCategoryCellView.h"
#import "Parts.h"

@implementation PartsTableDataDelegate
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
    return [[[Parts dictionary] objectForKey:PartsKeyCategory] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartsCategoryCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"PartsCategoryCell"];
    if (cell == nil) {
        UIViewController* controller;
        controller = [[UIViewController alloc] initWithNibName:@"PartsCategoryCellView" bundle:nil];
        cell = (PartsCategoryCellView*)controller.view;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        NSString* category = [[[Parts dictionary] objectForKey:PartsKeyCategory] objectAtIndex:indexPath.row];
        [cell set:category];
        [cell registerNotification];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
@end
