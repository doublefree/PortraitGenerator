//
//  CategoryListView.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 5/5/13.
//
//

#import "CategoryListView.h"
#import "Parts.h"
#import "PartsCategoryCellView.h"

@interface CategoryListView()
@end


@implementation CategoryListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    int count = [[[Parts dictionary] objectForKey:PartsKeyCategory] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController* controller;
    controller = [[UIViewController alloc] initWithNibName:@"PartsCategoryCellView" bundle:nil];
    PartsCategoryCellView* cell = (PartsCategoryCellView*)controller.view;
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    NSString* category = [[[Parts dictionary] objectForKey:PartsKeyCategory] objectAtIndex:indexPath.row];
    [cell set:category];
    [cell registerNotification];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CATEGORY_CELL_HEIGHT+2;
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
