//
//  LVDataSetSettingsViewController.h
//  Log Viewer
//
//  Created by Jon on 9/19/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LVDataSet.h"
#import "LVGraphView.h"

@interface LVDataSetSettingsViewController : UIViewController <LVGraphViewDelegate>

- (NSUInteger)numDataSetsForGraphView:(LVGraphView *)graphView;
- (LVDataSet *)graphView:(LVGraphView *)graphView dataSetForSetWithIndex:(NSUInteger)index;

@property (strong, nonatomic) LVDataSet *dataSet;

@end
