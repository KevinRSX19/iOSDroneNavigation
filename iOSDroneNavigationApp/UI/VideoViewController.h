//
//  VideoViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/29/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VideoViewMode) {
    VideoViewMode_ViewMode,
    VideoViewMode_MiniMode,
};

@class VideoViewController;

@protocol VideoViewControllerDelegate<NSObject>

- (void) videoClickedInVideoVC:(VideoViewController *)VideoVC;

@end

@interface VideoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *videoView;

@property (assign, nonatomic) VideoViewMode mode;
@property (weak, nonatomic) id <VideoViewControllerDelegate> delegate;

- (IBAction)videoClicked:(id)sender;

@end
