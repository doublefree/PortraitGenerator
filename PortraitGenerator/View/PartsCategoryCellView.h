//
//  PartsCellView.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/23/13.
//
//

#import <UIKit/UIKit.h>

@interface PartsCategoryCellView : UITableViewCell
@property (retain, nonatomic) IBOutlet UIButton *button;
-(void)set:(NSString*)category;
-(void)registerNotification;
@end
