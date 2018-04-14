//
//  VideoViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/29/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "VideoViewController.h"
#import <DJISDK/DJISDK.h>
#import <VideoPreviewer/VideoPreviewer.h>


@interface VideoViewController ()<DJIVideoFeedListener>

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setMode:VideoViewMode_ViewMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMode:(VideoViewMode)mode{
    _mode = mode;
//    if (_mode == VideoViewMode_MiniMode) {
//        [_videoView setFrame:CGRectMake(20, 243, 207, 112)];
//    }else {
//        [_videoView setFrame:CGRectMake(0, 0, 667, 375)];
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[VideoPreviewer instance] setView:self.videoView];
    [[DJISDKManager videoFeeder].primaryVideoFeed addListener:self withQueue:nil];
    [[VideoPreviewer instance] start];
    //    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    //    [self focusMe];
}

#pragma mark - DJIVideoFeedListener
-(void)videoFeed:(DJIVideoFeed *)videoFeed didUpdateVideoData:(NSData *)videoData {
    [[VideoPreviewer instance] push:(uint8_t *)videoData.bytes length:(int)videoData.length];
}

- (IBAction)videoClicked:(id)sender {
    if (_mode == VideoViewMode_MiniMode) {
        [self setMode:VideoViewMode_ViewMode];
        if ([_delegate respondsToSelector:@selector(videoClickedInVideoVC:)]) {
            [_delegate videoClickedInVideoVC:self];
        }
    }
}
@end
