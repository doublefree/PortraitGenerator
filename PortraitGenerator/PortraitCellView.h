//
//  PortraitCellView.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import <UIKit/UIKit.h>

@interface PortraitCellView : UITableViewCell
+(float) cellHeight;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@end
