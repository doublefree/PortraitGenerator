//
//  PortraitDetailViewController.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/28/13.
//
//

#import "PortraitDetailViewController.h"
#import "Portrait.h"

const NSString* IMAGE_POST_URL = @"http://wiz-r.com/portrait/save.php";
const NSString* SHOW_URL_FORMAT = @"http://wiz-r.com/portrait/show.php?id=%@";
const NSString* IMAGE_URL_FORMAT = @"http://wiz-r.com/portrait/data/%@.png";

@interface PortraitDetailViewController ()
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) UIImage* image;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *titleTextField;
- (IBAction)lineButtonPushed:(id)sender;
- (IBAction)closeButtonPushed:(id)sender;
- (IBAction)smsButtonPushed:(id)sender;
- (IBAction)fbButtonPushed:(id)sender;
@end

@implementation PortraitDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString*)name
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.name = name;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSDictionary* dictionary = [[Portrait list] objectForKey:self.name];
    self.titleTextField.text = self.name;
    self.image = [UIImage imageWithData:[dictionary objectForKey:@"image"]];
    self.imageView.image = self.image;
    
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_titleTextField release];
    [_imageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTitleTextField:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}
- (IBAction)lineButtonPushed:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName];
    [pasteboard setData:UIImagePNGRepresentation(self.image) forPasteboardType:@"public.png"];
    NSString *LINEUrlString = [NSString stringWithFormat:@"line://msg/image/%@", pasteboard.name];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LINEUrlString]];
}

- (IBAction)closeButtonPushed:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.window.rootViewController.view cache:YES];
    [self.view removeFromSuperview];
    [UIView commitAnimations];
}

- (IBAction)smsButtonPushed:(id)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)fbButtonPushed:(id)sender {
    if (FBSession.activeSession.isOpen) {
        [self postToFB];
    } else {
        AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:YES completion:^(FBSession* session, FBSessionState state, NSError* error){
            if (FBSession.activeSession.isOpen) {
                [self postToFB];
            }
        }];
    }
}

- (void)postToFB
{
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         reauthorizeWithPublishPermissions: [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 [self postToFB];
             }
         }];
        return;
    }
    
    NSString* message = @"My Portrait is here!!";
    NSString* appDescription = @"Face Maker";
    
    NSString* imageUrlDefault = @"http://wiz-r.com/portrait/images/appicon.png";
    NSString* imageId = [self uploadPngFile];
    NSString* imageUrl = nil;
    NSString* url = nil;
    if (!imageId || [imageId isEqualToString:@"NG"]) {
        imageUrl = imageUrlDefault;
        url = @"http://bit.ly/17HA7If";
    } else {
        imageUrl = [NSString stringWithFormat:(NSString*)IMAGE_URL_FORMAT, imageId];
        url = [NSString stringWithFormat:(NSString*)SHOW_URL_FORMAT, imageId];
    }
    
    NSMutableDictionary* postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       url, @"link",
                                       imageUrl, @"picture",
                                       message, @"name",
                                       @"Face Maker :)", @"caption",
                                       appDescription, @"description",
                                       nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:postParams HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              ;;
                          }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString*)uploadPngFile
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:(NSString*)IMAGE_POST_URL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------168072824752491622650073";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"upfile\"; filename=\"portrait.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(self.image)]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *filename = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    return filename;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ABMultiValueRef phoneRef = ABRecordCopyValue(person, kABPersonPhoneProperty);    
    if (ABMultiValueGetCount(phoneRef) > 0) {
        NSString* phone = (NSString *)(ABMultiValueCopyValueAtIndex(phoneRef, 0));
        
        if(![MFMessageComposeViewController canSendText]) {
            return NO;
        }
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        
        NSString* imageId = [self uploadPngFile];
        if ([imageId isEqualToString:@"NG"]) {
            return NO;
        }
        NSString* body = [NSString stringWithFormat:(NSString*)SHOW_URL_FORMAT, imageId];
        picker.body = body;
        picker.recipients = [NSArray arrayWithObjects:phone, nil];
        [peoplePicker dismissViewControllerAnimated:YES completion:^(void){
            [self presentModalViewController:picker animated:YES];
        }];
        return NO;
    } else {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return YES;
}
@end
