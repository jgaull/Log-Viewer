//
//  LVViewController.h
//  Log Viewer
//
//  Created by Jon on 9/18/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ModeoFramework/ModeoFramework.h>
#import <ModeoFramework/ModeoController.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

#import "LVGraphView.h"

@interface LVViewController : UIViewController <MKMapViewDelegate, LVGraphViewDelegate>

@property (strong, nonatomic) PFObject *ride;

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;

- (NSUInteger)numDataSetsForGraphView:(LVGraphView *)graphView;
- (LVDataSet *)graphView:(LVGraphView *)graphView dataSetForSetWithIndex:(NSUInteger)index;

@end
