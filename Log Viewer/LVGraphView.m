//
//  LVGraphView.m
//  Log Viewer
//
//  Created by Jon on 9/18/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import "LVGraphView.h"
#import "LVDataPoint.h"

@implementation LVGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didMoveToSuperview {
    [self setNeedsDisplay];
}

- (void)reload {
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    float viewHeight = self.frame.size.height;
    float viewWidth = self.frame.size.width;
    
    NSUInteger numDataSets = [self.delegate numDataSetsForGraphView:self];
    
    for (NSUInteger i = 0; i < numDataSets; i++) {
        LVDataSet *dataSet = [self.delegate graphView:self dataSetForSetWithIndex:i];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:dataSet.first.cgPoint];
        
        for (int i = 0; i < dataSet.count; i++) {
            LVDataPoint *dataPoint = [dataSet dataPointAtIndex:i];
            CGPoint percentagePosition = [dataSet percentagePositionForDataPoint:dataPoint];
            
            CGPoint point = CGPointMake(viewWidth * percentagePosition.x, viewHeight - viewHeight * percentagePosition.y);
            [path addLineToPoint:point];
        }
        
        [dataSet.color setStroke];
        [path stroke];
    }
}

@end
