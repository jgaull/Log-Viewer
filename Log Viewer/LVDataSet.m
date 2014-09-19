//
//  LVDataSet.m
//  Log Viewer
//
//  Created by Jon on 9/18/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import "LVDataSet.h"

@interface LVDataSet ()

@property (strong, nonatomic) NSArray *data;

@end

@implementation LVDataSet

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        self.data = [[NSArray alloc] initWithArray:array];
        
        _topLeft = [[LVDataPoint alloc] initWithX:DBL_MAX andY:DBL_MIN];
        _bottomRight = [[LVDataPoint alloc] initWithX:DBL_MIN andY:DBL_MAX];
        
        for (LVDataPoint *dataPoint in self.data) {
            
            if (dataPoint.x < self.topLeft.x) {
                _topLeft.x = dataPoint.x;
            }
            if (dataPoint.y > self.topLeft.y) {
                _topLeft.y = dataPoint.y;
            }
            
            if (dataPoint.x > self.bottomRight.x) {
                _bottomRight.x = dataPoint.x;
            }
            if (dataPoint.y < self.bottomRight.y) {
                _bottomRight.y = dataPoint.y;
            }
        }
    }
    return self;
}

- (LVDataPoint *)dataPointAtIndex:(NSInteger)index {
    return [self.data objectAtIndex:index];
}

- (CGPoint)percentagePositionForDataPoint:(LVDataPoint *)dataPoint {
    
    double zeroedX = dataPoint.x - self.topLeft.x;
    double zeroedY = dataPoint.y - self.bottomRight.y;
    
    float xPercent = zeroedX / self.width;
    float yPercent = zeroedY / self.height;
    
    return CGPointMake(xPercent, yPercent);
}

- (double)width {
    return self.bottomRight.x - self.topLeft.x;
}

- (double)height {
    return self.topLeft.y - self.bottomRight.y;
}

- (LVDataPoint *)first {
    return self.data.firstObject;
}

- (LVDataPoint *)last {
    return self.data.lastObject;
}

- (NSUInteger)count {
    return self.data.count;
}

@end
