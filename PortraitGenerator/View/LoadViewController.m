//
//  LoadViewController.m
//  PortraitGenerator
//
//  Created by Watabe Takuya on 3/2/13.
//
//

#import "LoadViewController.h"
#import "PortraitCellView.h"
#import "Portrait.h"

@interface LoadViewController ()
- (IBAction)closeButtonPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSString* selectedName;

@end

int const AlertTagDeletePortrait = 1;

@implementation LoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(loadButtonPushed:) name:NOTIFICATION_LOAD_BUTTON_PUSHED object:nil];
    [nc addObserver:self selector:@selector(deleteButtonPushed:) name:NOTIFICATION_DELETE_BUTTON_PUSHED object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Portrait count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* portraitList = [Portrait list];
    NSArray* nameList = [portraitList allKeys];
    UIViewController* controller;
    
    controller = [[UIViewController alloc] initWithNibName:@"PortraitCellView" bundle:nil];
    PortraitCellView* cell = (PortraitCellView*)controller.view;
    
    NSString* name = [nameList objectAtIndex:indexPath.row];
    cell.nameLabel.text = name;
    NSDictionary* dictionary = [portraitList objectForKey:name];
    NSData* data = [dictionary objectForKey:@"image"];
    cell.image.image = [UIImage imageWithData:data];
    
    UISwipeGestureRecognizer* gestureRight = [[UISwipeGestureRecognizer alloc]
     initWithTarget:cell action:@selector(didSwipeCell:)];
    gestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [cell addGestureRecognizer:gestureRight];
    
    UISwipeGestureRecognizer* gestureLeft = [[UISwipeGestureRecognizer alloc]
                                         initWithTarget:cell action:@selector(didSwipeCell:)];
    gestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:gestureLeft];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* portraitList = [Portrait list];
    NSArray* nameList = [portraitList allKeys];
    NSString* name = [nameList objectAtIndex:indexPath.row];
    
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:name forKey:@"name"];
    NSNotification* nc = [NSNotification notificationWithName:NOTIFICATION_LOAD_BUTTON_PUSHED object:self userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotification:nc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PortraitCellView cellHeight];
}

- (IBAction)closeButtonPushed:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view.window.rootViewController.view cache:YES];
    [self.view removeFromSuperview];
    [UIView commitAnimations];
}

-(void)loadButtonPushed:(NSNotification*)center{
    NSString* name = [[center userInfo] objectForKey:@"name"];
    self.selectedName = name;
    if ([name length] != 0) {
        NSDictionary* dictionary = [NSDictionary dictionaryWithObject:name forKey:@"name"];
        NSNotification* nc = [NSNotification notificationWithName:NOTIFICATION_LOAD_WITH_NAME object:self userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] postNotification:nc];
    }
}

-(void)deleteButtonPushed:(NSNotification*)center{
    NSString* name = [[center userInfo] objectForKey:@"name"];
    self.selectedName = name;
    if ([name length] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"load_delete_confirm_title", @"DeleteConfirm") message:[NSString stringWithFormat:NSLocalizedString(@"load_delete_confirm_message", @"delete_confirm"), name] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.tag = AlertTagDeletePortrait;
        [alert show];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertTagDeletePortrait) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [Portrait removeWithName:self.selectedName];
                [self.tableView reloadData];
                break;
            default:
                break;
        }
    }
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
