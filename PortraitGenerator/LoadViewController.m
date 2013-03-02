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

@end

@implementation LoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    NSMutableArray* nameList = [Portrait nameList];
    PortraitCellView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PortraitCell"];
    if (cell == nil) {
        UIViewController* controller;
        controller = [[UIViewController alloc] initWithNibName:@"PortraitCellView" bundle:nil];
        cell = (PortraitCellView*)controller.view;
        NSString* name = [nameList objectAtIndex:indexPath.row];
        cell.nameLabel.text = name;
        //cell.nameLabel.text = @"hogehoge";
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
- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
