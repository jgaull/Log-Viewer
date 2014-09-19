//
//  LVRidesTableViewController.m
//  Log Viewer
//
//  Created by Jon on 9/19/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import "LVRidesTableViewController.h"
#import "LVViewController.h"

@interface LVRidesTableViewController ()

@end

@implementation LVRidesTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = @"ride";
        self.textKey = @"objectId";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", object.createdAt];
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[LVViewController class]]) {
        LVViewController *viewController = (LVViewController *)segue.destinationViewController;
        PFObject *ride = [self objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        viewController.ride = ride;
    }
}

@end
