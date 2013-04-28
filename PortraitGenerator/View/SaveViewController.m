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
    if (self.name) {
        self.textField.text = self.name;
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
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL );
    NSString* name = self.textField.text;
    [Portrait add:self.figureSet withName:name image:self.image];
    
    PortraitDetailViewController* detailViewController = [[PortraitDetailViewController alloc] initWithNibName:@"PortraitDetailViewController" bundle:nil name:name];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.window.rootViewController.view cache:YES];
    [self.view.window.rootViewController.view addSubview:detailViewController.view];
    [UIView commitAnimations];
    [self.view removeFromSuperview];
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

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if(!error){
        NSLog(@"no error");
    } else {
        NSLog(@"error");
    }
}

- (void)dealloc {
    [_imageView release];
    [_textField release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setTextField:nil];
    [super viewDidUnload];
}
@end
