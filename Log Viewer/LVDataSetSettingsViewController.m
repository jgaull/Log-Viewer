//
//  LVDataSetSettingsViewController.m
//  Log Viewer
//
//  Created by Jon on 9/19/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import "LVDataSetSettingsViewController.h"

@interface LVDataSetSettingsViewController ()

@property (weak, nonatomic) IBOutlet LVGraphView *graphView;
@property (weak, nonatomic) IBOutlet UISlider *smoothingSlider;
@property (weak, nonatomic) IBOutlet UILabel *smoothingLabel;

@end

@implementation LVDataSetSettingsViewController

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
    self.title = self.dataSet.name;
    self.graphView.delegate = self;
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSUInteger)numDataSetsForGraphView:(LVGraphView *)graphView {
    return 1;
}

- (LVDataSet *)graphView:(LVGraphView *)graphView dataSetForSetWithIndex:(NSUInteger)index {
    return self.dataSet;
}

- (IBAction)smoothingSliderDidChange:(UISlider *)sender {
    self.dataSet.smoothing = sender.value;
    [self updateUI];
}

- (void)updateUI {
    self.smoothingSlider.value = self.dataSet.smoothing;
    self.smoothingLabel.text = [NSString stringWithFormat:@"Smoothing %.2f%%", self.dataSet.smoothing * 100];
    [self.graphView reload];
}

@end
