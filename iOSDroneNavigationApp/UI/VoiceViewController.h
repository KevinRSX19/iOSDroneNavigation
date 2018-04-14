//
//  VoiceViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/30/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import "FollowmeConfigModel.h"

@class VoiceViewController;

@protocol VoiceViewControllerDelegate<NSObject>

- (void)closeBtnActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)voiceBtnActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)configActionInVoiceVC:(VoiceViewController *)VoiceVC;

- (void)takeoffActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)landingActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)followmeConfigInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)followmeActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)tolocationActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)exploreActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)cleaningVCommandActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)cleaningHCommandActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)cleaningExecuteActionInVoiceVC:(VoiceViewController *)VoiceVC;
- (void)stopActionInVoiceVC:(VoiceViewController *)VoiceVC;

@end

@interface VoiceViewController : UIViewController<SFSpeechRecognizerDelegate> {
    SFSpeechRecognizer *speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
    AVAudioEngine *audioEngine;
}

@property (weak, nonatomic) IBOutlet UILabel *recogniseString;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextView *commandPanel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (nonatomic, copy) NSString* speech;
@property (nonatomic, copy) NSString* command;
@property (nonatomic) FollowmeConfigModel *followmeSetting;

@property (weak, nonatomic) id <VoiceViewControllerDelegate> delegate;

- (IBAction)closeBtnAction:(id)sender;
- (IBAction)voiceBtnAction:(id)sender;

- (void)loadFollowmeSetting:(FollowmeConfigModel *)followmeSetting;
- (void)addSpeechCommand:(NSString *)speech;
- (void)clearSpeechCommandPanel;

@end
