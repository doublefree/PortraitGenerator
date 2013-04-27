//
//  SaveViewController.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/27/13.
//
//

#import <UIKit/UIKit.h>
#import "FigureSet.h"

@interface SaveViewController : UIViewController <UITextFieldDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage*)image figureSet:(FigureSet*)figureSet;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage*)image figureSet:(FigureSet*)figureSet name:(NSString*)name;
@end
