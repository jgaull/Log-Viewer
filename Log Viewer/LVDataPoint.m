//
//  LVDataPoint.m
//  Log Viewer
//
//  Created by Jon on 9/18/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import "LVDataPoint.h"

@implementation LVDataPoint

- (id)initWithX:(double)x andY:(double)y {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

- (CGPoint)cgPoint {
    return CGPointMake(self.x, self.y);
}

@end
