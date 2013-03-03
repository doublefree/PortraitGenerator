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
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(loadButtonPushed:) name:NOTIFICATION_LOAD_BUTTON_PUSHED object:nil];
        [nc addObserver:self selector:@selector(deleteButtonPushed:) name:NOTIFICATION_DELETE_BUTTON_PUSHED object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    return @"Setting";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Portrait count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* portraitList = [Portrait list];
    NSArray* nameList = [portraitList allKeys];
    PortraitCellView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PortraitCell"];
    if (cell == nil) {
        UIViewController* controller;
        controller = [[UIViewController alloc] initWithNibName:@"PortraitCellView" bundle:nil];
        cell = (PortraitCellView*)controller.view;
        NSString* name = [nameList objectAtIndex:indexPath.row];
        cell.nameLabel.text = name;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PortraitCellView cellHeight];
}

- (IBAction)closeButtonPushed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)loadButtonPushed:(NSNotification*)center{
    NSString* name = [[center userInfo] objectForKey:@"name"];
    self.selectedName = name;
    if ([name length] != 0) {
        NSDictionary* dictionary = [NSDictionary dictionaryWithObject:name forKey:@"name"];
        NSNotification* nc = [NSNotification notificationWithName:NOTIFICATION_LOAD_WITH_NAME object:self userInfo:dictionary];
        [[NSNotificationCenter defaultCenter] postNotification:nc];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)deleteButtonPushed:(NSNotification*)center{
    NSString* name = [[center userInfo] objectForKey:@"name"];
    self.selectedName = name;
    if ([name length] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Confirm" message:[NSString stringWithFormat:@"Really remove %@?", name] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
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
                break;
            default:
                break;
        }
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
