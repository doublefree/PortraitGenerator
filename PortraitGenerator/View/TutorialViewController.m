//
//  TutorialViewController.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 5/6/13.
//
//

#import "TutorialViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TutorialViewController ()
@property (retain, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)closeButtonPushed:(id)sender;

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.frame = CGRectMake(10,10,300,460);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.view layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.view layer] setBorderWidth:2.0];
    
    UIScrollView* webScrollView = [[self.webview subviews] lastObject];
    if([webScrollView respondsToSelector:@selector(setScrollEnabled:)]){
        [webScrollView setScrollEnabled:NO];
    }
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tutorial" ofType:@"html"]isDirectory:NO]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webview release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebview:nil];
    [super viewDidUnload];
}
- (IBAction)closeButtonPushed:(id)sender {
    [self.view removeFromSuperview];
}
@end
