//
//  PartsListView.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/24/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PartsListView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) NSString* category;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
