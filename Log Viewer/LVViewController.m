//
//  LVViewController.m
//  Log Viewer
//
//  Created by Jon on 9/18/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <Parse/Parse.h>

#import "LVViewController.h"
#import "MEDataPoint.h"


@interface LVViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet LVGraphView *graphView;

@property (strong, nonatomic) MKPolyline *routeLine;
@property (nonatomic) MKMapRect routeRect;
@property (strong, nonatomic) MKPolylineView *routeLineView;

@property (strong, nonatomic) NSArray *locationData;
@property (strong, nonatomic) LVDataSet *altitudeDataSet;
@property (strong, nonatomic) NSArray *dataSets;

@end

@implementation LVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor grayColor], [UIColor blackColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor cyanColor], [UIColor magentaColor], [UIColor purpleColor]];
    
    self.graphView.delegate = self;
    
    NSString *objectId = @"5RGTXu8pSr";
    PFObject *rideLog = [PFObject objectWithClassName:@"ride"];
    rideLog.objectId = objectId;
    [rideLog refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NSLog(@"loaded");
            PFFile *log = [object objectForKey:@"log"];
            [log getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    NSLog(@"Log loaded");
                    
                    NSError *error;
                    NSArray *dataPointDictionaries = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    
                    NSMutableArray *dataPoints = [NSMutableArray new];
                    
                    for (NSDictionary *dictionary in dataPointDictionaries) {
                        MEDataPoint *dataPoint = [[MEDataPoint alloc] initWithDictionary:dictionary];
                        [dataPoints addObject:dataPoint];
                    }
                    
                    NSMutableArray *locationDatems = [NSMutableArray new];
                    NSMutableArray *altitudeData = [NSMutableArray new];
                    
                    NSMutableDictionary *sortedSensorData = [NSMutableDictionary new];
                    
                    for (MEDataPoint *dataPoint in dataPoints) {
                        if (dataPoint.type == kDataPointTypeSensor) {
                            
                            MFSensorData *sensorData = (MFSensorData *)dataPoint.dataObject;
                            
                            NSMutableArray *dataForSensor = [sortedSensorData objectForKey:[NSNumber numberWithInteger:sensorData.sensor]];
                            if (!dataForSensor) {
                                dataForSensor = [NSMutableArray new];
                                [sortedSensorData setObject:dataForSensor forKey:[NSNumber numberWithInteger:sensorData.sensor]];
                            }
                            
                            [dataForSensor addObject:sensorData];
                        }
                        else if (dataPoint.type == kDataPointTypeLocation) {
                            CLLocation *location = (CLLocation *)dataPoint.dataObject;
                            [locationDatems addObject:location];
                            
                            LVDataPoint *altitudeDataPoint = [[LVDataPoint alloc] initWithX:[location.timestamp timeIntervalSince1970] andY:location.altitude];
                            [altitudeData addObject:altitudeDataPoint];
                        }
                    }
                    
                    NSMutableArray *mutableDataSets = [NSMutableArray new];
                    
                    for (NSNumber *key in sortedSensorData) {
                        
                        NSMutableArray *sensorDatems = [sortedSensorData objectForKey:key];
                        
                        NSMutableArray *mutableSensorDataPoints = [NSMutableArray new];
                        
                        for (MFSensorData *sensorData in sensorDatems) {
                            
                            LVDataPoint *dataPoint = [[LVDataPoint alloc] initWithX:[sensorData.timestamp timeIntervalSince1970] andY:sensorData.value];
                            [mutableSensorDataPoints addObject:dataPoint];
                        }
                        
                        LVDataSet *sensorDataSet = [[LVDataSet alloc] initWithArray:mutableSensorDataPoints];
                        MFSensorData *first = sensorDatems.firstObject;
                        
                        sensorDataSet.name = [NSString stringWithFormat:@"Sensor %d", first.sensor];
                        sensorDataSet.color = [colors objectAtIndex:mutableDataSets.count];
                        [mutableDataSets addObject:sensorDataSet];
                    }
                    
                    LVDataSet *altitudeDataSet = [[LVDataSet alloc] initWithArray:altitudeData];
                    altitudeDataSet.name = @"altitude";
                    altitudeDataSet.color = [colors objectAtIndex:mutableDataSets.count];
                    [mutableDataSets addObject:altitudeDataSet];
                    
                    self.dataSets = [[NSArray alloc] initWithArray:mutableDataSets];
                    
                    self.locationData = [[NSArray alloc] initWithArray:locationDatems];
                    
                    [self drawRouteOnMap];
                    [self.graphView reload];
                }
                else {
                    NSLog(@"Error loading file: %@", error.localizedDescription);
                }
            }];
        }
        else {
            NSLog(@"Error loading ride: %@", error.localizedDescription);
        }
    }];
}

- (void)drawRouteOnMap {
    MKMapPoint northEast;
    MKMapPoint southWest;
    
    MKMapPoint *pointArr = malloc(sizeof(CLLocationCoordinate2D) * self.locationData.count);
    
    for (int i = 0; i < self.locationData.count; i++) {
        CLLocation *location = [self.locationData objectAtIndex:i];
        MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
        pointArr[i] = point;
        
        if (i == 0) {
            northEast = point;
            southWest = point;
        }
        
        if (point.x > northEast.x) {
            northEast.x = point.x;
        }
        
        if(point.y > northEast.y) {
            northEast.y = point.y;
        }
        
        if (point.x < southWest.x) {
            southWest.x = point.x;
        }
        
        if (point.y < southWest.y) {
            southWest.y = point.y;
        }
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:self.locationData.count];
    self.routeRect = MKMapRectMake(southWest.x, southWest.y, northEast.x, northEast.y);
    
    free(pointArr);
    
    [self.mapView addOverlay:self.routeLine];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if (![overlay isKindOfClass:[MKPolyline class]]) {
        return nil;
    }
    
    MKPolyline *routeLine = (MKPolyline *)overlay;
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:routeLine];
    renderer.strokeColor = [UIColor redColor];
    return renderer;
}

- (NSUInteger)numDataSetsForGraphView:(LVGraphView *)graphView {
    return self.dataSets.count;
}

- (LVDataSet *)graphView:(LVGraphView *)graphView dataSetForSetWithIndex:(NSUInteger)index {
    return [self.dataSets objectAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
