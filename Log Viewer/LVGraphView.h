//
//  LVGraphView.h
//  Log Viewer
//
//  Created by Jon on 9/18/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVDataSet.h"

@class LVGraphView;

@protocol LVGraphViewDelegate <NSObject>

- (NSUInteger)numDataSetsForGraphView:(LVGraphView *)graphView;
- (LVDataSet *)graphView:(LVGraphView *)graphView dataSetForSetWithIndex:(NSUInteger)index;

@end

@interface LVGraphView : UIView

@property (weak, nonatomic) NSObject<LVGraphViewDelegate> *delegate;

- (void)reload;

@end
