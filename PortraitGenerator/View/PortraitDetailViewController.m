//
//  PortraitDetailViewController.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 4/28/13.
//
//

#import "PortraitDetailViewController.h"
#import "Portrait.h"

@interface PortraitDetailViewController ()
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) UIImage* image;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *titleTextField;
- (IBAction)lineButtonPushed:(id)sender;
- (IBAction)closeButtonPushed:(id)sender;
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
@end
