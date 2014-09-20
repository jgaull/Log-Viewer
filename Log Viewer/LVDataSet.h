//
//  LVDataSet.h
//  Log Viewer
//
//  Created by Jon on 9/18/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LVDataPoint.h"

@interface LVDataSet : NSObject

- (id)initWithArray:(NSArray *)array;

- (LVDataPoint *)dataPointAtIndex:(NSInteger)index;
- (CGPoint)percentagePositionForDataPoint:(LVDataPoint *)dataPoint;

@property (readonly) NSUInteger count;
@property (readonly) LVDataPoint *first;
@property (readonly) LVDataPoint *last;
@property (readonly) LVDataPoint *topLeft;
@property (readonly) LVDataPoint *bottomRight;
@property (readonly) double width;
@property (readonly) double height;
@property (nonatomic) float smoothing;

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSString *name;

@end
