//
//  SaveViewController.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/27/13.
//
//

#import "SaveViewController.h"
#import "Portrait.h"
#import "PortraitDetailViewController.h"

@interface SaveViewController ()
- (IBAction)cancelButtonPushed:(id)sender;
- (IBAction)okButtonPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) UIImage* image;
@property (retain, nonatomic) FigureSet* figureSet;
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (retain, nonatomic) IBOutlet UIButton *saveButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@end

@implementation SaveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage*)image figureSet:(FigureSet*)figureSet
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil image:image figureSet:figureSet name:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage*)image figureSet:(FigureSet*)figureSet name:(NSString*)name
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.image = image;
        self.figureSet = figureSet;
        self.name = name;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.imageView.image = self.image;
    self.textField.placeholder = NSLocalizedString(@"save_text_placeholder", @"Please Input the Name of Portrait");
    //self.saveButton.titleLabel.text = NSLocalizedString(@"save_button_text", @"Save");
    //self.cancelButton.titleLabel.text = NSLocalizedString(@"save_cancel_button_text", @"Cancel");
    if ([self.name length] > 0) {
        self.textField.text = self.name;
    } else {
        ;
    }
    self.textField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPushed:(id)sender {
    [self closeView];
}

- (IBAction)okButtonPushed:(id)sender {
    NSString* name = self.textField.text;
    
    if ([name length] <= 0) {
        NSDateFormatter* refDateFormattter = [[NSDateFormatter alloc] init];
        [refDateFormattter setDateFormat:@"yyyy-MM-dd"];
        name = [refDateFormattter stringFromDate:[NSDate date]];
    }
    
    self.name = name;
    
    NSMutableDictionary* portraitList = [Portrait list];
    NSArray* nameList = [portraitList allKeys];
    for(NSString* portraitName in nameList){
        if ([name isEqualToString:portraitName]) {
            NSString* title = NSLocalizedString(@"save_overwite_dialog_title", @"Error");
            NSString* message = NSLocalizedString(@"save_dialog_message_duplicate_portrait", @"Please input title");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
    }
    
    [self saveAndClose];
}

- (void)saveAndClose
{
    [Portrait add:self.figureSet withName:self.name image:self.image];
    
    PortraitDetailViewController* detailViewController = [[PortraitDetailViewController alloc] initWithNibName:@"PortraitDetailViewController" bundle:nil name:self.name];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.window.rootViewController.view cache:YES];
    [self.view.window.rootViewController.view addSubview:detailViewController.view];
    [UIView commitAnimations];
    [self.view removeFromSuperview];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"Canceled");
            break;
        case 1:
            [self saveAndClose];
            NSLog(@"Saved");
            break;
        default:
            break;
    }
}

- (void)closeView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.window.rootViewController.view cache:YES];
    [self.view removeFromSuperview];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [_imageView release];
    [_textField release];
    [_saveButton release];
    [_cancelButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setTextField:nil];
    [self setSaveButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
}
@end
