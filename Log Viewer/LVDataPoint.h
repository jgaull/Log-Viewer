//
//  LVDataPoint.h
//  Log Viewer
//
//  Created by Jon on 9/18/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVDataPoint : NSObject

- (id)initWithX:(double)x andY:(double)y;

@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic, readonly) CGPoint cgPoint;

@end
