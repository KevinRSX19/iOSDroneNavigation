//
//  MapViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/29/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DJIMapController.h"

typedef NS_ENUM(NSUInteger, MapViewMode) {
    MapViewMode_ViewMode,
    MapViewMode_MiniMode,
};

typedef NS_ENUM(NSUInteger, ToLocationMode) {
    ToLocationMode_FinishedMode,
    ToLocationMode_StartMode,
    ToLocationMode_AddMode,
};

typedef NS_ENUM(NSUInteger, FollowmeMode) {
    FollowmeMode_Following,
    FollowmeMode_Stopped,
};

@class MapViewController;

@protocol MapViewControllerDelegate<NSObject>

- (void) mapClickedInMapVC:(MapViewController *)MapVC;
- (void) addBtnClickedInMapVC:(MapViewController *)MapVC;
- (void) configBtnClickedInMapVC:(MapViewController *)MapVC;
- (void) finishAddBtnClickedInMapVC:(MapViewController *)MapVC;

@end

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *configBtn;
@property (nonatomic, strong) DJIMapController *mapController;
@property (weak, nonatomic) IBOutlet UILabel *lon;
@property (weak, nonatomic) IBOutlet UILabel *lat;

@property(nonatomic, assign) CLLocationCoordinate2D userLocation;
@property(nonatomic, assign) CLLocationCoordinate2D droneLocation;
@property(nonatomic, strong) CLLocationManager* locationManager;

@property (assign, nonatomic) MapViewMode mode;
@property (assign, nonatomic) ToLocationMode locationMode;
@property (assign, nonatomic) FollowmeMode followmeMode;
@property (weak, nonatomic) id <MapViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;

- (IBAction)MapClicked:(id)sender;
- (IBAction)focusBtnAction:(id)sender;
- (IBAction)addBtnAction:(id)sender;
- (IBAction)stopBtnAction:(id)sender;
- (IBAction)clearBtnAction:(id)sender;
- (IBAction)configBtnAction:(id)sender;
- (void) setMode:(MapViewMode)mode;
- (void) setToLocationMode:(ToLocationMode)mode;
- (void) setFollowmeMode:(FollowmeMode)followmeMode;
- (CLLocationCoordinate2D)getUserLocation;
- (CLLocationCoordinate2D)getDroneLocation;
- (void) clearPinPoints;

@end
