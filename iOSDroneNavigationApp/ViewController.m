//
//  ViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/17/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "ViewController.h"
#import "LeftButtonListViewController.h"
#import "RightButtonListViewController.h"
#import "MapViewController.h"
#import "VideoViewController.h"
#import "CheckListTableViewController.h"
#import "VoiceViewController.h"
#import "TakeoffViewController.h"
#import "AddPinViewController.h"
#import "ToLocationConfigViewController.h"
#import "FollowmeConfigViewController.h"
#import "LandingViewController.h"
#import "ExploreConfigViewController.h"
#import "GimbleViewController.h"
#import "OthersViewController.h"
#import "CleaningViewController.h"
#import "VirtualStickCleaningViewController.h"
#import <DJISDK/DJISDK.h>
#import "DemoUtility.h"

#import "WayPointModel.h"
#import "DroneStatusModel.h"
#import "FollowmeConfigModel.h"

#define ONE_METER_OFFSET (0.00000901315)
#define ANGAL_TO_RAD_OFFSET (0.01745329)

@interface ViewController () <DJISDKManagerDelegate,LeftButtonListViewControllerDelegate,RightButtonListViewControllerDelegate,MapViewControllerDelegate,VideoViewControllerDelegate,CheckListTableViewControllerDelegate,VoiceViewControllerDelegate,TakeoffViewControllerDelegate,AddPinViewControllerDelegate,ToLocationConfigViewControllerDelegate,FollowmeConfigViewControllerDelegate,LandingViewControllerDelegate,ExploreConfigViewControllerDelegate,GimbleViewControllerDelegate,DJIFlightControllerDelegate,DJIRemoteControllerDelegate,DJIBatteryDelegate,OthersViewControllerDelegate,CleaningViewControllerDelegate,VirtualStickCleaningViewControllerDelegate>

@property (strong, nonatomic) LeftButtonListViewController* leftBtnVC;
@property (strong, nonatomic) RightButtonListViewController* rightBtnVC;
@property (strong, nonatomic) MapViewController* mapVC;
@property (strong, nonatomic) VideoViewController* videoVC;
@property (strong, nonatomic) CheckListTableViewController* checkListTableVC;
@property (strong, nonatomic) VoiceViewController* voiceVC;

@property (strong, nonatomic) TakeoffViewController* takeoffVC;
@property (strong, nonatomic) LandingViewController* landingVC;
@property (strong, nonatomic) AddPinViewController* addPinVC;
@property (strong, nonatomic) ToLocationConfigViewController* toLocationConfigVC;
@property (strong, nonatomic) FollowmeConfigViewController* folloemeConfigVC;
@property (strong, nonatomic) ExploreConfigViewController* exploreConfigVC;
@property (strong, nonatomic) GimbleViewController* gimbleVC;
@property (strong, nonatomic) OthersViewController* othersVC;
@property (strong, nonatomic) CleaningViewController* cleaningVC;
@property (strong, nonatomic) VirtualStickCleaningViewController* vsCleaningVC;

//@property(nonatomic, assign) CLLocationCoordinate2D userLocation;
@property(nonatomic, assign) CLLocationCoordinate2D homeLocation;
@property(nonatomic, assign) CLLocationCoordinate2D droneLocation;
@property(nonatomic, assign) double altitude;
@property double heading;

@property (nonatomic, copy) NSString * mode;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsLabel;

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@property (assign, nonatomic) MissionMode missionMode;

@property (retain, nonatomic) DroneStatusModel *droneStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    const DDLogLevel ddLogLevel = DDLogLevelVerbose;
    
    //init app
    [self initUI];
    [self registerApp];
    _mode = @"camera";
    _status.text = @"";
    _missionMode = MissionMode_Nothing;
    
    self.droneStatus = [[DroneStatusModel alloc] init];
    
    //test
    double lat = [DemoUtility MeterToLat:100];
    double lon = [DemoUtility MeterToLon:100 :23.14*ANGAL_TO_RAD_OFFSET];
    NSLog(@"lat:%f, lon:%f",lat,lon);
    
    double maxDistance = 3;
    CLLocationCoordinate2D user = CLLocationCoordinate2DMake(37.352, -121.863);
    CLLocationCoordinate2D drone = CLLocationCoordinate2DMake(37.3522, -121.8635);
    double k =  [DemoUtility LatToMeter:(user.latitude-drone.latitude)]/[DemoUtility LonToMeter :(user.longitude-drone.longitude) :drone.latitude];
    NSLog(@"x2:%f, y2:%f",[DemoUtility LatToMeter:(user.latitude-drone.latitude)],[DemoUtility LonToMeter :(user.longitude-drone.longitude) :drone.latitude]);
    double ang = atan(k);
    NSLog(@"k:%f, ang:%f, tan(ang):%f",k,ang/ANGAL_TO_RAD_OFFSET,tan(ang));
    //if user is going to the west of the drone
    //        if(self.userLocation.longitude<self.droneLocation.longitude)
    //            maxDistance = -maxDistance;
    double x = cos(ang) * maxDistance;
    double y = sin(ang) * maxDistance;
    NSLog(@"x:%f, y:%f",x,y);
    double k1 = y/x;
    double ang1 = atan(k1);
    NSLog(@"k1:%f, ang1:%f",k1,ang1/ANGAL_TO_RAD_OFFSET);
    CLLocationCoordinate2D followPoint = CLLocationCoordinate2DMake(drone.latitude + [DemoUtility MeterToLat:x], drone.longitude + [DemoUtility MeterToLon:y :drone.latitude]);
    NSLog(@"Follow Point:[%f, %f]",followPoint.latitude,followPoint.longitude);
    double kk =  [DemoUtility LatToMeter:(user.latitude-followPoint.latitude)]/[DemoUtility LonToMeter :(user.longitude-followPoint.longitude) :followPoint.latitude];
    double kkang = atan(kk);
    NSLog(@"x2:%f, y2:%f",[DemoUtility LatToMeter:(user.latitude-followPoint.latitude)],[DemoUtility LonToMeter :(user.longitude-followPoint.longitude) :followPoint.latitude]);
    NSLog(@"kk:%f, kkang:%f",kk,kkang/ANGAL_TO_RAD_OFFSET);
}

#pragma mark Custom Methods

- (void)registerApp
{
    //Please enter the App Key in the info.plist file to register the app.
    [DJISDKManager registerAppWithDelegate:self];
}

- (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark DJISDKManagerDelegate Method

- (void)productConnected:(DJIBaseProduct *)product
{
    if (product) {
        //TODO: set connection mode: connected
        [self.leftBtnVC.takeoffBtn setEnabled:YES];
        _status.text = @"product connected!";
        DDLogInfo(@"product connected!");
        DJIFlightController* flightController = [DemoUtility fetchFlightController];
        if (flightController) {
            flightController.delegate = self;
        }else{
            ShowMessage(@"flight controller delegate failed", nil, nil, @"ok");
            DDLogError(@"flight controller delegate failed");
        }
    }else
    {
        [self productDisconnected];
        [self.leftBtnVC.takeoffBtn setEnabled:NO];
        _status.text = @"product disconnected!";
        DDLogError(@"product disconnected!");
    }
    
    //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
    //    [[DJISDKManager userAccountManager] logIntoDJIUserAccountWithAuthorizationRequired:NO withCompletion:^(DJIUserAccountState state, NSError * _Nullable error) {
    //        if (error) {
    //            ShowResult(@"Login failed: %@", error.description);
    //        }
    //    }];
}

- (void)productDisconnected
{
    //TODO: set connection mode: disconnected
}

- (void)appRegisteredWithError:(NSError *)error
{
    NSString* message = @"register app successed";
    if (error) {
        message = @"Register App Failed! Please enter your App Key and check the network.";
        [self productDisconnected];
        [self showAlertViewWithTitle:@"Register App" withMessage:message];
    }else
    {
        NSLog(@"registerAppSuccess");
        _status.text = @"app registered!";
#if ENTER_DEBUG_MODE
        [DJISDKManager enableBridgeModeWithBridgeAppIP:@"192.168.1.101"];
#else
        [DJISDKManager startConnectionToProduct];
#endif
    }
    //    [self showAlertViewWithTitle:@"Register App" withMessage:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    //UI Views
    self.leftBtnVC = [[LeftButtonListViewController alloc] initWithNibName:@"LeftButtonListViewController" bundle:[NSBundle mainBundle]];
    [self.leftBtnVC.view setFrame:CGRectMake(20, 90, self.leftBtnVC.view.frame.size.width, self.leftBtnVC.view.frame.size.height)];
    self.leftBtnVC.delegate = self;
    [self.view addSubview:self.leftBtnVC.view];
    
    self.rightBtnVC = [[RightButtonListViewController alloc] initWithNibName:@"RightButtonListViewController" bundle:[NSBundle mainBundle]];
    [self.rightBtnVC.view setFrame:CGRectMake(self.view.frame.size.width - 20 - self.rightBtnVC.view.frame.size.width, 90, self.rightBtnVC.view.frame.size.width, self.rightBtnVC.view.frame.size.height)];
    self.rightBtnVC.delegate = self;
    [self.view addSubview:self.rightBtnVC.view];
    
    self.videoVC = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:[NSBundle mainBundle]];
    self.videoVC.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.videoVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.videoVC.delegate = self;
    [self.backView addSubview:self.videoVC.view];
    
    self.mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:[NSBundle mainBundle]];
    self.mapVC.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.mapVC.view setFrame:CGRectMake(20, self.view.frame.size.height - 142, 207, 112)];
    NSLog(@"init size: %f",self.backView.frame.size.height);
    NSLog(@"init view size: %f",self.view.frame.size.height);
    self.mapVC.delegate = self;
    [self.backView addSubview:self.mapVC.view];
    
    self.checkListTableVC = [[CheckListTableViewController alloc] initWithNibName:@"CheckListTableViewController" bundle:[NSBundle mainBundle]];
    self.checkListTableVC.view.alpha = 0;
    self.checkListTableVC.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.checkListTableVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.checkListTableVC.view setCenter:self.view.center];
    self.checkListTableVC.delegate = self;
    [self.view addSubview:self.checkListTableVC.view];
    
    self.voiceVC = [[VoiceViewController alloc] initWithNibName:@"VoiceViewController" bundle:[NSBundle mainBundle]];
    self.voiceVC.delegate = self;
    self.voiceVC.view.alpha = 0;
    self.voiceVC.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.voiceVC.view setFrame:CGRectMake(self.view.frame.size.width - self.voiceVC.view.frame.size.width, 0, self.voiceVC.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.voiceVC.view];
    
    self.othersVC = [[OthersViewController alloc] initWithNibName:@"OthersViewController" bundle:[NSBundle mainBundle]];
    self.othersVC.delegate = self;
    self.othersVC.view.alpha = 0;
    self.othersVC.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.othersVC.view setFrame:CGRectMake(self.view.frame.size.width - self.othersVC.view.frame.size.width, 0, self.othersVC.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.othersVC.view];
    
    self.vsCleaningVC = [[VirtualStickCleaningViewController alloc] initWithNibName:@"VirtualStickCleaningViewController" bundle:[NSBundle mainBundle]];
    self.vsCleaningVC.delegate = self;
    self.vsCleaningVC.view.alpha = 0;
    self.vsCleaningVC.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.vsCleaningVC.view setFrame:CGRectMake(0, self.view.frame.size.height - self.vsCleaningVC.view.frame.size.height, self.view.frame.size.width, self.vsCleaningVC.view.frame.size.height)];
    [self.view addSubview:self.vsCleaningVC.view];
    
    //Mission Config UIs
    self.landingVC = [[LandingViewController alloc] initWithNibName:@"LandingViewController" bundle:[NSBundle mainBundle]];
    self.landingVC.delegate = self;
    [self initConfigView:self.landingVC];
    
    self.takeoffVC = [[TakeoffViewController alloc] initWithNibName:@"TakeoffViewController" bundle:[NSBundle mainBundle]];
    self.takeoffVC.delegate = self;
    [self initConfigView:self.takeoffVC];
    
    self.addPinVC = [[AddPinViewController alloc] initWithNibName:@"AddPinViewController" bundle:[NSBundle mainBundle]];
    self.addPinVC.delegate = self;
    [self initConfigView:self.addPinVC];
    
    self.toLocationConfigVC = [[ToLocationConfigViewController alloc] initWithNibName:@"ToLocationConfigViewController" bundle:[NSBundle mainBundle]];
    self.toLocationConfigVC.delegate = self;
    [self initConfigView:self.toLocationConfigVC];
    
    self.folloemeConfigVC = [[FollowmeConfigViewController alloc] initWithNibName:@"FollowmeConfigViewController" bundle:[NSBundle mainBundle]];
    [self initConfigView:self.folloemeConfigVC];
    self.folloemeConfigVC.delegate = self;
    
    self.exploreConfigVC = [[ExploreConfigViewController alloc] initWithNibName:@"ExploreConfigViewController" bundle:[NSBundle mainBundle]];
    self.exploreConfigVC.delegate = self;
    [self initConfigView:self.exploreConfigVC];
    
    self.gimbleVC = [[GimbleViewController alloc] initWithNibName:@"GimbleViewController" bundle:[NSBundle mainBundle]];
    self.gimbleVC.delegate = self;
    [self initConfigView:self.gimbleVC];
    
    self.cleaningVC = [[CleaningViewController alloc] initWithNibName:@"CleaningViewController" bundle:[NSBundle mainBundle]];
    self.cleaningVC.delegate = self;
    [self initConfigView:self.cleaningVC];
}

- (void)initConfigView:(UIViewController *)VC {
    VC.view.alpha = 0;
    VC.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [VC.view setCenter:self.view.center];
    [self.view addSubview:VC.view];
}

#pragma LBtnList implement
- (void)takeoffBtnActionInLBtnVC:(LeftButtonListViewController *)LBtnVC {
    NSLog(@"takeoff btn clicked");
    [UIView animateWithDuration:0.25 animations:^{
        self.takeoffVC.view.alpha = 1;
        [self hideButtons];
    }];
}

- (void)landingBtnActionInLBtnVC:(LeftButtonListViewController *)LBtnVC {
    NSLog(@"landing btn clicked");
    [UIView animateWithDuration:0.25 animations:^{
        self.landingVC.view.alpha = 1;
        [self hideButtons];
    }];
}

- (void)followMeBtnActionInLBtnVC:(LeftButtonListViewController *)LBtnVC {
    NSLog(@"follow me btn clicked");
    [self.folloemeConfigVC loadDefaultSettings:[self.folloemeConfigVC.followmeMission getDefaultSettings]];
    [UIView animateWithDuration:0.25 animations:^{
        self.folloemeConfigVC.view.alpha = 1;
        [self hideButtons];
    }];
}

#pragma RBtnList implement
- (void)exploreBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC {
    NSLog(@"explore btn clicked");
    [UIView animateWithDuration:0.25 animations:^{
        self.exploreConfigVC.view.alpha = 1;
        [self hideButtons];
    }];
}

- (void)gimbleBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC {
    NSLog(@"gimble btn clicked");
    if ([_mode isEqualToString:@"map"]) {
        [self videoClickedInVideoVC:_videoVC];
        [_videoVC setMode:VideoViewMode_ViewMode];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.gimbleVC.view.alpha = 1;
        [self hideButtons];
    }];
}

- (void)tolocationBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC {
    NSLog(@"to location btn clicked");
    if ([_mode isEqualToString:@"camera"]) {
        [self mapClickedInMapVC:_mapVC];
        [_mapVC setMode:MapViewMode_ViewMode];
    }
    [_mapVC setToLocationMode:ToLocationMode_StartMode];
}

- (void)cleaningBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC {
    NSLog(@"cleaning btn clicked");
    [UIView animateWithDuration:0.25 animations:^{
        self.cleaningVC.view.alpha = 1;
        [self hideButtons];
    }];
}

- (void)stopBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC {
    [self stopMission];
}

#pragma MapVC implement
- (void)mapClickedInMapVC:(MapViewController *)MapVC {
    NSLog(@"map clicked");
    //set map to full size
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [_mapVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    [_videoVC.view setAlpha:0];
    [_videoVC.view setFrame:CGRectMake(20, self.view.frame.size.height - 137, 207, 112)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelay:1];
    [_videoVC.view setAlpha:1];
    [UIView commitAnimations];
    NSLog(@"change size: %f",self.backView.frame.size.height);
    NSLog(@"change view size: %f",self.view.frame.size.height);
    [_backView bringSubviewToFront:_videoVC.view];
    [_videoVC setMode:VideoViewMode_MiniMode];
    _mode = @"map";
}

- (void)addBtnClickedInMapVC:(MapViewController *)MapVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.addPinVC.view.alpha = 1;
        [self hideButtons];
    }];
}

- (void)configBtnClickedInMapVC:(MapViewController *)MapVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.toLocationConfigVC.view.alpha = 1;
        [self hideButtons];
    }];
}

- (void)finishAddBtnClickedInMapVC:(MapViewController *)MapVC {
    //finish add way points
}

#pragma VideoVC implement
- (void)videoClickedInVideoVC:(VideoViewController *)VideoVC {
    NSLog(@"video clicked");
    //set map to mini size
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [_videoVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    [_mapVC.view setAlpha:0];
    [_mapVC.view setFrame:CGRectMake(20, self.view.frame.size.height - 137, 207, 112)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelay:1];
    [_mapVC.view setAlpha:1];
    [UIView commitAnimations];
    [_backView bringSubviewToFront:_mapVC.view];
    [_mapVC setMode:MapViewMode_MiniMode];
    _mode = @"camera";
    [_mapVC setToLocationMode:ToLocationMode_FinishedMode];
}

- (void)configActionInVoiceVC:(VoiceViewController *)VoiceVC {
    if ([self.voiceVC.command containsString:@"followme"]) {
        [UIView animateWithDuration:0.25 animations:^{
            self.folloemeConfigVC.view.alpha = 1;
            [self hideButtons];
        }];
    } else if ([self.voiceVC.command containsString:@"tolocation"]) {
        if (self.mapVC.mode == MapViewMode_MiniMode){
            //set map to full size
            [_mapVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [_videoVC.view setFrame:CGRectMake(20, self.view.frame.size.height - 137, 207, 112)];
            NSLog(@"change size: %f",self.backView.frame.size.height);
            NSLog(@"change view size: %f",self.view.frame.size.height);
            [_backView bringSubviewToFront:_videoVC.view];
            [_videoVC setMode:VideoViewMode_MiniMode];
            _mode = @"map";
            [self.mapVC setMode:MapViewMode_ViewMode];
        }
        [self.mapVC setToLocationMode:ToLocationMode_StartMode];
    }
}

#pragma drone status check list
- (IBAction)statusBtnClicked:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.checkListTableVC.view.alpha = 1.0;
        [self hideButtons];
    }];
}

- (void)closeBtnClickedInCheckListTVC:(CheckListTableViewController *)CheckListTVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.checkListTableVC.view.alpha = 0;
        [self showButtons];
    }];
}

#pragma VoiceVC implement
- (IBAction)voiceControlBtnClicked:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.voiceVC.view.alpha = 1.0;
        [self hideButtons];
    }];
}

- (void)closeBtnActionInVoiceVC:(VoiceViewController *)VoiceVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.voiceVC.view.alpha = 0;
        [self showButtons];
    }];
    [self.voiceVC clearSpeechCommandPanel];
}

- (void)voiceBtnActionInVoiceVC:(VoiceViewController *)VoiceVC {
    
}

- (void)takeoffActionInVoiceVC:(VoiceViewController *)VoiceVC {
    [self takeoffMission];
}

- (void)landingActionInVoiceVC:(VoiceViewController *)VoiceVC {
    [self landingMission];
}

- (void)followmeConfigInVoiceVC:(VoiceViewController *)VoiceVC {
    FollowmeConfigModel *fm = [self.folloemeConfigVC.followmeMission getDefaultSettings];
    [self.voiceVC setFollowmeSetting:fm];
    self.voiceVC.speech = [self.voiceVC.speech stringByAppendingString:[NSString stringWithFormat:@"GPS signal: %@ \n",self.gpsLabel.text]];
    self.voiceVC.speech = [self.voiceVC.speech stringByAppendingString:[NSString stringWithFormat:@"max fly height: %@m \n",fm.maxFlyHeight]];
    self.voiceVC.speech = [self.voiceVC.speech stringByAppendingString:[NSString stringWithFormat:@"max fly speed: %@m \n",fm.maxFlySpeed]];
}

- (void)followmeActionInVoiceVC:(VoiceViewController *)VoiceVC {
    [self.folloemeConfigVC startFollowmeMission:self.voiceVC.followmeSetting];
}

- (void)tolocationActionInVoiceVC:(VoiceViewController *)VoiceVC {
    //TODO
}

- (void)exploreActionInVoiceVC:(VoiceViewController *)VoiceVC {
    //TODO
}

- (void)stopActionInVoiceVC:(VoiceViewController *)VoiceVC {
    [self stopMission];
}

- (void)cleaningVCommandActionInVoiceVC:(VoiceViewController *)VoiceVC {
    _cleaningVC.mode.selectedSegmentIndex = 0;
    NSMutableArray* points = [self cleaningVSetup:3 :3 :3];
    if (points == nil) {
        return;
    }
    [self.toLocationConfigVC setCleaningConfig:points];
}

- (void)cleaningHCommandActionInVoiceVC:(VoiceViewController *)VoiceVC {
    _cleaningVC.mode.selectedSegmentIndex = 1;
    NSMutableArray* points = [self cleaningHSetup:3 :3 :3];
    if (points == nil) {
        return;
    }
    [self.toLocationConfigVC setCleaningConfig:points];
}

- (void)cleaningExecuteActionInVoiceVC:(VoiceViewController *)VoiceVC {
    [self cleaningMission];
}

#pragma Mission Config - takeoff
- (void)CancelBtnActionInTakeoffVC:(TakeoffViewController *)TakeoffVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.takeoffVC.view.alpha = 0;
        [self showButtons];
    }];
}

- (void)TakeoffBtnActionInTakeoffVC:(TakeoffViewController *)TakeoffVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.takeoffVC.view.alpha = 0;
        [self showButtons];
    }];
    [self takeoffMission];
}

#pragma Add Pin
- (void)setBtnClickedInAddPinVC:(AddPinViewController *)AddPinVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.addPinVC.view.alpha = 0;
        [self showButtons];
    }];
    
    if(self.addPinVC.type.selectedSegmentIndex==1){
        float lat = [self.addPinVC.lat.text floatValue];
        float lon = [self.addPinVC.lon.text floatValue];
        CLLocation* location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        [self.mapVC.mapController addLocationPoint:location withMapView:self.mapVC.mapView];
        //TODO: add three pin points between target and user
    }else{
        NSString* address = self.addPinVC.address.text;
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(error != nil || placemarks.count == 0) {
                return;
            }else{
                CLPlacemark *firstPlacemark = [placemarks firstObject];
                CLLocation* location = firstPlacemark.location;
                [self.mapVC.mapController addLocationPoint:location withMapView:self.mapVC.mapView];
                //TODO: add three pin points between target and user
            }
        }];
    }
}

- (void)cancelBtnClickedInAddPinVC:(AddPinViewController *)AddPinVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.addPinVC.view.alpha = 0;
        [self showButtons];
    }];
}

#pragma to location config
- (void)startBtnActionInLocaConfigVC:(ToLocationConfigViewController *)LocaConfigVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.toLocationConfigVC.view.alpha = 0;
        [self showButtons];
    }];
    
    [self.mapVC clearPinPoints];
    _missionMode = MissionMode_ToLocation;
}

- (void)cancelBtnActionInLocaConfigVC:(ToLocationConfigViewController *)LocaConfigVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.toLocationConfigVC.view.alpha = 0;
        [self showButtons];
    }];
    [self.mapVC clearPinPoints];
}

- (void)uploadBtnActionInLocaConfigVC:(ToLocationConfigViewController *)LocaConfigVC {
    NSArray* points = [self.mapVC.mapController wayPoints];
    [self.toLocationConfigVC setFlightConfig:points];
    [self.toLocationConfigVC.statusLabel setText:@""];
}

#pragma follow me config
- (void)startBtnActionInFollowmeConfigVC:(FollowmeConfigViewController *)FollowmeVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.folloemeConfigVC.view.alpha = 0;
        [self showButtons];
    }];
    [self.mapVC setFollowmeMode:FollowmeMode_Following];
    _missionMode = MissionMode_Followme;
}

- (void)cancelBtnActionInFollowmeConfigVC:(FollowmeConfigViewController *)FollowmeVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.folloemeConfigVC.view.alpha = 0;
        [self showButtons];
    }];
    [self.mapVC setFollowmeMode:FollowmeMode_Stopped];
}

#pragma landing
- (void)landingBtnActionInLandingVC:(LandingViewController *)LandingVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.landingVC.view.alpha = 0;
        [self showButtons];
    }];
    [self landingMission];
}

- (void)cancelBtnActionInLandingVC:(LandingViewController *)LandingVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.landingVC.view.alpha = 0;
        [self showButtons];
    }];
}

#pragma gimble
- (void)startBtnActionInGimbleVC:(GimbleViewController *)GimbleVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.gimbleVC.view.alpha = 0;
        [self showButtons];
    }];
}

- (void)cancelBtnActionInGimbleVC:(GimbleViewController *)GimbleVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.gimbleVC.view.alpha = 0;
        [self showButtons];
    }];
}

#pragma explore
- (void)startBtnActionInExploreVC:(ExploreConfigViewController *)ExploreVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.exploreConfigVC.view.alpha = 0;
        [self showButtons];
    }];
    _missionMode = MissionMode_Explore;
}

- (void)cancelBtnActionInExploreVC:(ExploreConfigViewController *)ExploreVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.exploreConfigVC.view.alpha = 0;
        [self showButtons];
    }];
}

#pragma others configuration
- (IBAction)othersAction:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.othersVC.view.alpha = 1;
        [self hideButtons];
    }];
    [self.othersVC displayMaxFlightHeight];
    [self.othersVC displayFlightRadiusLimitation];
}

- (void)closeBtnActionInOthersVC:(OthersViewController *)OthersVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.othersVC.view.alpha = 0;
        [self showButtons];
    }];
}

#pragma cleaning configuration
-(void)uploadBtnActionInCleaningVC:(CleaningViewController *)CleaningVC {
    NSMutableArray* points = [[NSMutableArray alloc] init];
    double height = [self.cleaningVC.g_height.text intValue];
    if (self.altitude < height + 1) {
        ShowResult(@"Drone have no enough altitude!");
        return;
    }
    if(self.cleaningVC.mode.selectedSegmentIndex == 0) {
        //vertical cleaning
        int lt = [self.cleaningVC.g_length.text intValue];
        points = [self cleaningVSetup:lt :height :[self.cleaningVC.flightInterval.text intValue]];
        if (points == nil) {
            return;
        }
    } else {
        //horizonal cleaning
        int lt = [self.cleaningVC.g_length.text intValue];
        points = [self cleaningHSetup:lt :height :[self.cleaningVC.flightInterval.text intValue]];
    }
    
    [self.toLocationConfigVC setCleaningConfig:points];
}

-(void)startBtnActionInCleaningVC:(CleaningViewController *)CleaningVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.cleaningVC.view.alpha = 0;
        [self showButtons];
    }];
    [self cleaningMission];
}

-(void)cancelBtnActionInCleaningVC:(CleaningViewController *)CleaningVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.cleaningVC.view.alpha = 0;
        [self showButtons];
    }];
}

#pragma mark DJIFlightControllerDelegate
- (void)flightController:(DJIFlightController *)fc didUpdateState:(DJIFlightControllerState *)state
{
    //TODO: load status information to status checking list
    if (state.isHomeLocationSet) {
        self.mapVC.droneLocation = state.aircraftLocation.coordinate;
    }
    self.droneLocation = state.aircraftLocation.coordinate;
    [self.folloemeConfigVC updateDroneLocationDemo:self.droneLocation];
    self.homeLocation = state.homeLocation.coordinate;
    self.altitude = state.altitude;
    self.heading = fc.compass.heading;
    [self.mapVC.lat setText:[NSString stringWithFormat:@"%f",self.mapVC.droneLocation.latitude]];
    [self.mapVC.lon setText:[NSString stringWithFormat:@"%f",self.mapVC.droneLocation.longitude]];
    self.modelLabel.text = state.flightModeString;
    
    NSString *gps = [self.folloemeConfigVC setGPSSignalLevel:state.GPSSignalLevel];
    [self.gpsLabel setText:gps];
    self.vertialSpeed.text = [NSString stringWithFormat:@"%0.1f M/S",state.velocityZ];
    self.horizonSpeed.text = [NSString stringWithFormat:@"%0.1f M/S",(sqrtf(state.velocityX*state.velocityX + state.velocityY*state.velocityY))];
    self.distanceLabal.text = [NSString stringWithFormat:@"%f", [FollowmeMissionController calculateDistanceBetweenPoint:self.droneLocation andPoint:self.mapVC.userLocation]];
    
    [self.mapVC.mapController updateAircraftLocation:self.mapVC.droneLocation withMapView:self.mapVC.mapView];
    double radianYaw = RADIAN(state.attitude.yaw);
    [self.mapVC.mapController updateAircraftHeading:radianYaw];
    [self.status setText:[NSString stringWithFormat:@"%f,%f",self.heading,self.altitude]];
    
    //load status check list data
    self.droneStatus.flightMode = state.flightModeString;
    self.droneStatus.compass = [NSString stringWithFormat:@"%d",fc.compass.hasError];
    [self.checkListTableVC loadFCStatus:_droneStatus];
}

- (void)flightController:(DJIFlightController *)fc didUpdateIMUState:(DJIIMUState *)imuState {
    self.droneStatus.IMU = [self descriptionForIMUSensorState:imuState.accelerometerState];
    [self.checkListTableVC loadIMUState:_droneStatus];
}

- (NSString *)descriptionForIMUSensorState:(DJIIMUSensorState)state {
    switch (state) {
        case DJIIMUSensorStateWarmingUp:
            return @"IMU Warning Up";
        case DJIIMUSensorStateCalibrating:
            return @"Calibrating";
        case DJIIMUSensorStateNormalBias:
            return @"Normal";
            break;
        case DJIIMUSensorStateMediumBias:
            return @"Medium(Normal)";
            break;
        case DJIIMUSensorStateLargeBias:
            return @"Need Calibration";
            break;
        case DJIIMUSensorStateDataException:
            return @"Need Calibration and Restart Aircraft";
            break;
        case DJIIMUSensorStateCalibrationFailed:
            return @"Calibration Failed";
            break;
        case DJIIMUSensorStateDisconnected:
            return @"Disconnected";
            break;
        case DJIIMUSensorStateUnknown:
            return @"Unknown";
            break;
        default:
            break;
    }
    return @"Unknown";
}

- (void)remoteController:(DJIRemoteController *)rc didUpdateChargeRemaining:(DJIRCChargeRemaining)chargeRemaining {
    self.droneStatus.RCBattery =[NSString stringWithFormat:@"%u",chargeRemaining.remainingChargeInmAh];
    [self.checkListTableVC loadRCState:_droneStatus];
}
//
//- (void)remoteController:(DJIRemoteController *)rc didUpdateHardwareState:(DJIRCHardwareState)state {
//    self.droneStatus.flightMode = state.flightModeSwitch;
//}

- (void)battery:(DJIBattery *)battery didUpdateState:(DJIBatteryState *)state {
    [self.BatteryLabel setText:[NSString stringWithFormat:@"%ld",state.chargeRemainingInPercent]];
    self.droneStatus.aircraftBattery = [NSString stringWithFormat:@"%ld",state.chargeRemainingInPercent];
    self.droneStatus.aircraftBatteryTemp = [NSString stringWithFormat:@"%f",state.temperature];
    [self.checkListTableVC loadAircraftBatteryState:_droneStatus];
}

#pragma mark DJI mission control
- (void)takeoffMission{
    [self.takeoffVC executeTakeoff];
    _missionMode = MissionMode_TakeOff;
}

- (void)landingMission{
    [self.landingVC executeLanding];
    _missionMode = MissionMode_Landing;
}

- (void)homingMission {
    [self.landingVC executeGoHome];
    _missionMode = MissionMode_GoHome;
}

- (void)followmeMission{
    
}

- (void)tolocationMission{
    
}

- (void)exploreMission{
    
}

- (NSMutableArray *)cleaningVSetup:(int) lt :(double)height :(int)interval{
    NSMutableArray* points = [[NSMutableArray alloc] init];
    if (interval<=0) {
        interval = 2;
    }
    //calculate GPS consider heading
    double ang,latLt,lonLt;
    if(_heading>=0 && _heading<180){
        //facing NE & SE
        ang = _heading*ANGAL_TO_RAD_OFFSET;
        latLt = cos(ang)*lt;
        lonLt = -sin(ang)*lt;
    }else if(0>_heading && _heading>-180){
        //facing NW & SW
        ang = -_heading*ANGAL_TO_RAD_OFFSET;
        latLt = cos(ang)*lt;
        lonLt = sin(ang)*lt;
    }else{
        ShowResult(@"heading info error!, %f",_heading);
        return nil;
    }
    double tar = self.altitude, temp = self.altitude;
    while (temp-tar<height) {
        WayPointModel *point1 = [[WayPointModel alloc]init];
        point1.altitude = tar;
        point1.wayPoint = CLLocationCoordinate2DMake(self.droneLocation.latitude + latLt * ONE_METER_OFFSET, self.droneLocation.longitude + lonLt * ONE_METER_OFFSET);
        [points addObject:point1];
        tar = tar - interval * 0.1;
        WayPointModel *point2 = [[WayPointModel alloc]init];
        point2.altitude = tar;
        point2.wayPoint = CLLocationCoordinate2DMake(self.droneLocation.latitude, self.droneLocation.longitude);
        [points addObject:point2];
    }
    return points;
}

- (NSMutableArray *)cleaningHSetup:(int) lt :(double)height :(int)interval{
    NSMutableArray* points = [[NSMutableArray alloc] init];
    if (interval<=0) {
        interval = 2;
    }
    double ang,latLt,lonLt;
    //calculate GPS consider heading
    if(_heading>=0 && _heading<180){
        //facing NE & SE
        ang = _heading*ANGAL_TO_RAD_OFFSET;
        latLt = cos(ang);
        lonLt = -sin(ang);
    }else if(0>_heading && _heading>-180){
        //facing NW & SW
        ang = -_heading*ANGAL_TO_RAD_OFFSET;
        latLt = cos(ang);
        lonLt = sin(ang);
    }else{
        ShowResult(@"heading info error!, %f",_heading);
        return nil;
    }
    double tar = self.altitude;
    double lonth = 0;
    while (lonth<lt) {
        WayPointModel *point1 = [[WayPointModel alloc]init];
        point1.altitude = tar-height;
        point1.wayPoint = CLLocationCoordinate2DMake(self.droneLocation.latitude + lonth * latLt * ONE_METER_OFFSET, self.droneLocation.longitude + lonth * lonLt * ONE_METER_OFFSET);
        [points addObject:point1];
        lonth = lonth + interval * 0.1;
        WayPointModel *point3 = [[WayPointModel alloc]init];
        point3.altitude = tar;
        point3.wayPoint = CLLocationCoordinate2DMake(self.droneLocation.latitude + lonth * latLt * ONE_METER_OFFSET, self.droneLocation.longitude + lonth * lonLt * ONE_METER_OFFSET);
        [points addObject:point3];
    }
    return points;
}

- (void)cleaningMission{
//    [self.toLocationConfigVC onStartButtonClicked];
    [UIView animateWithDuration:0.25 animations:^{
        self.vsCleaningVC.view.alpha = 1.0;
        [self hideButtons];
    }];
    
    if(self.cleaningVC.mode.selectedSegmentIndex == 0) {
        //vertical cleaning
        [self.vsCleaningVC startVSCleaning:[self.cleaningVC.g_length.text doubleValue] height:[self.cleaningVC.g_height.text doubleValue] cleaningMode:CleaningMode_VerMode];
    } else {
        //horizonal cleaning
        [self.vsCleaningVC startVSCleaning:[self.cleaningVC.g_length.text doubleValue] height:[self.cleaningVC.g_height.text doubleValue] cleaningMode:CleaningMode_HoriMode];
    }
    _missionMode = MissionMode_Cleaning;
}

- (void)stopCleaningActionInVSCleaningVC:(VirtualStickCleaningViewController *)VSCleaningVC {
    [UIView animateWithDuration:0.25 animations:^{
        self.vsCleaningVC.view.alpha = 0;
        [self showButtons];
    }];
}

-(void)stopMission{
    NSLog(@"Stop all missions");
    switch (_missionMode) {
        case MissionMode_Followme:
            [self.folloemeConfigVC stopMission];
            break;
        case MissionMode_Cleaning:
//            [self.toLocationConfigVC stopMission];
            [self.vsCleaningVC stopMission];
            break;
        case MissionMode_Explore:
            [self.exploreConfigVC stopMission];
            break;
        case MissionMode_Landing:
            [self.landingVC stopMission];
            break;
        case MissionMode_ToLocation:
            [self.toLocationConfigVC stopMission];
            break;
        case MissionMode_TakeOff:
            //TODO
            [self.takeoffVC stopMission];
            break;
        case MissionMode_Nothing:
            //            [self.folloemeConfigVC stopMission];
            break;
            
        default:
            break;
    }
}

-(void)hideButtons {
    self.leftBtnVC.view.alpha = 0;
    self.rightBtnVC.view.alpha = 0;
    self.voiceBtn.alpha = 0;
    self.topBarView.alpha = 0;
    self.status.alpha = 0;
    self.distanceLabal.alpha = 0;
    self.horizonSpeed.alpha = 0;
    self.vertialSpeed.alpha = 0;
    
}

-(void)showButtons {
    self.leftBtnVC.view.alpha = 1;
    self.rightBtnVC.view.alpha = 1;
    self.voiceBtn.alpha = 1;
    self.topBarView.alpha = 1;
    self.status.alpha = 1;
    self.distanceLabal.alpha = 1;
    self.horizonSpeed.alpha = 1;
    self.vertialSpeed.alpha = 1;
}

@end
