//
//  CategoryListView.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 5/5/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CategoryListView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
