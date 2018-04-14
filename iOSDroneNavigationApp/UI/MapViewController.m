//
//  MapViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/29/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <DJISDK/DJISDK.h>
#import "DJIMapController.h"
#import "DemoUtility.h"

@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate,  DJIFlightControllerDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setMode:MapViewMode_MiniMode];
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startUpdateLocation];
}

-(CLLocationCoordinate2D)getUserLocation {
    return self.userLocation;
}

-(CLLocationCoordinate2D)getDroneLocation {
    return self.droneLocation;
}

-(void)initData
{
    self.mapController = [[DJIMapController alloc] init];
    self.userLocation = kCLLocationCoordinate2DInvalid;
    self.droneLocation = kCLLocationCoordinate2DInvalid;
    self.droneLocation = CLLocationCoordinate2DMake(37.352, -121.863);
    
//    [self focusMap];
    [self setToLocationMode:ToLocationMode_FinishedMode];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;
    
    if ([DemoUtility fetchAircraft] != nil) { // the product is an aircraft
        if ([DemoUtility fetchFlightController]) {
            [[DemoUtility fetchFlightController] setDelegate:self];
        }
    }
}

- (void)setMode:(MapViewMode)mode {
    _mode = mode;
}

- (void) setFollowmeMode:(FollowmeMode)followmeMode {
    _followmeMode = followmeMode;
}

- (void)setToLocationMode:(ToLocationMode)mode {
    _locationMode = mode;
    [_focusBtn setHidden:(mode == ToLocationMode_FinishedMode)];
    [_addBtn setHidden:(mode == ToLocationMode_FinishedMode)];
    [_clearBtn setHidden:(mode == ToLocationMode_FinishedMode)];
    [_configBtn setHidden:(mode == ToLocationMode_FinishedMode)];
    [_stopAddBtn setHidden:(mode != ToLocationMode_AddMode)];
}

- (IBAction)MapClicked:(id)sender {
    if (_mode == MapViewMode_MiniMode) {
        if ([_delegate respondsToSelector:@selector(mapClickedInMapVC:)]) {
            [_delegate mapClickedInMapVC:self];
        }
        [self setMode:MapViewMode_ViewMode];
    }
    else if (_locationMode == ToLocationMode_AddMode) {
        //tap add pin point
        CGPoint point = [_tap locationInView:_mapView];
        [self.mapController addPoint:point withMapView:self.mapView];
    }
}

#pragma mark MKMapViewDelegate Method
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
        if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
            MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin_Annotation"];
            pinView.pinTintColor = [UIColor purpleColor];
            return pinView;

        }
        else if ([annotation isKindOfClass:[DJIAircraftAnnotation class]])
        {
            DJIAircraftAnnotationView* annoView = [[DJIAircraftAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Aircraft_Annotation"];
            ((DJIAircraftAnnotation*)annotation).annotationView = annoView;
            return annoView;
        }
    
    return nil;
}

- (IBAction)focusBtnAction:(id)sender {
//    [self focusMap];
//    self.mapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;
    
    [self focusMap];
    
//    if (CLLocationCoordinate2DIsValid(self.droneLocation)) {
//        MKCoordinateRegion region = {0};
//        region.center = self.droneLocation;
//        region.span.latitudeDelta = 0.001;
//        region.span.longitudeDelta = 0.001;
//        [self.mapView setRegion:region animated:YES];
//    }
}

- (IBAction)addBtnAction:(id)sender {
    if (self.locationMode == ToLocationMode_AddMode) {
        //open address panel
        if ([_delegate respondsToSelector:@selector(addBtnClickedInMapVC:)]) {
            [_delegate addBtnClickedInMapVC:self];
        }
    }
    [self setToLocationMode:ToLocationMode_AddMode];
}

- (IBAction)stopBtnAction:(id)sender {
    [self setToLocationMode:ToLocationMode_StartMode];
    if ([_delegate respondsToSelector:@selector(finishAddBtnClickedInMapVC:)]) {
        [_delegate finishAddBtnClickedInMapVC:self];
    }
}

- (IBAction)clearBtnAction:(id)sender {
    [self clearPinPoints];
}

- (void)clearPinPoints {
    [self.mapController cleanAllPointsWithMapView:self.mapView];
}

- (IBAction)configBtnAction:(id)sender {
    if (self.locationMode == ToLocationMode_AddMode) {
        [self setToLocationMode:ToLocationMode_StartMode];
    }
    //open config panel
    if ([_delegate respondsToSelector:@selector(configBtnClickedInMapVC:)]) {
        [_delegate configBtnClickedInMapVC:self];
    }
    [self setToLocationMode:ToLocationMode_FinishedMode];
}

- (void) focusMap
{
    if (CLLocationCoordinate2DIsValid(self.droneLocation)) {
        MKCoordinateRegion region = {0};
        region.center = self.droneLocation;
        region.span.latitudeDelta = 0.001;
        region.span.longitudeDelta = 0.001;

        [self.mapView setRegion:region animated:YES];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    self.userLocation = location.coordinate;
    if (_followmeMode == FollowmeMode_Following) {
        //update follow me user GPS
        
    }
}

-(void) startUpdateLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = 0.1;
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            [self.locationManager startMonitoringSignificantLocationChanges];
            [self.locationManager startUpdatingLocation];
        }
    } else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"warning message" message:@"Location Service is not available" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)productConnected:(DJIBaseProduct *)product {
    if (product) {
        DJIFlightController* flightController = [DemoUtility fetchFlightController];
        if (flightController) {
            flightController.delegate = self;
        }
        else {
            ShowMessage(@"Product disconnected", nil, nil, @"OK");
        }
    }
}

@end
