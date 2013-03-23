//
//  PartsTableDataDelegate.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/23/13.
//
//

#import "PartsTableDataDelegate.h"
#import "PartsCellView.h"

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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartsCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"PartsCell"];
    if (cell == nil) {
        UIViewController* controller;
        controller = [[UIViewController alloc] initWithNibName:@"PartsCellView" bundle:nil];
        cell = (PartsCellView*)controller.view;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
@end
