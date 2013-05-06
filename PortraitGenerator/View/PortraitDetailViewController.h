//
//  PortraitDetailViewController.h
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/28/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PortraitDetailViewController : UIViewController <MFMessageComposeViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString*)name;
@end
