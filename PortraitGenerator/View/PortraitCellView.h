//
//  PortraitCellView.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PortraitCellView : UITableViewCell
+(float) cellHeight;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *image;
@end
