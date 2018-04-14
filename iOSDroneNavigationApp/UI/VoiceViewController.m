//
//  VoiceViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/30/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "VoiceViewController.h"
#import <Speech/Speech.h>
//#import "TakeoffControl.h"
//#import "DJIController.h"
//#import "CleaningViewController.h"

@interface VoiceViewController () <SFSpeechRecognitionTaskDelegate>
@property (nonatomic, assign) int mode;
@property (nonatomic, assign) int temp;
/** 录音设备 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 监听设备 */
@property (nonatomic, strong) AVAudioRecorder *monitor;
/** 录音文件的URL */
@property (nonatomic, strong) NSURL *recordURL;
/** 监听器 URL */
@property (nonatomic, strong) NSURL *monitorURL;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

//@property (nonatomic, strong) TakeoffControl* takeoffC;
//@property (nonatomic, strong) DJIController* djiC;
//@property (nonatomic, strong) CleaningViewController* cleaningC;
@property int t;

@end

@implementation VoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
//    _takeoffC = [[TakeoffControl alloc] init];
//    _djiC = [[DJIController alloc] init];
//    _cleaningC = [[CleaningViewController alloc] init];
//    NSLog(@"takeoff hint:%@", [_takeoffC getTakeoffHint]);
    self.followmeSetting = [[FollowmeConfigModel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupSpeechPanel];
}

- (void)loadFollowmeSetting:(FollowmeConfigModel *)followmeSetting {
    self.followmeSetting = followmeSetting;
}

- (void)setup {
    //setup voice control
    [self requestSpeechAuthorization];
    self.command = @"";
    self.mode = 0;
    self.t = 0;
    
    // 参数设置
    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithFloat: 14400.0], AVSampleRateKey,
                                    [NSNumber numberWithInt: kAudioFormatAppleIMA4], AVFormatIDKey,
                                    [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                                    nil];
    
    NSString *recordPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"record.caf"];
    _recordURL = [NSURL fileURLWithPath:recordPath];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:_recordURL settings:recordSettings error:NULL];
    
    // 监听器
    NSString *monitorPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"monitor.caf"];
    _monitorURL = [NSURL fileURLWithPath:monitorPath];
    _monitor = [[AVAudioRecorder alloc] initWithURL:_monitorURL settings:recordSettings error:NULL];
    _monitor.meteringEnabled = YES;
}

- (void)setupSpeechPanel {
    _command = @"";
    _mode = 0;
    _speech = @"Voice Command, waiting for input.\n Avaliable commands: take off, follow me, landing, to location, explore, drone control, gimble control, help. \n";
    [self addSpeechCommand:_speech];
}

- (void)addSpeechCommand:(NSString *)speech {
    _commandPanel.text = [_commandPanel.text stringByAppendingString:speech];
    
    [_commandPanel setContentOffset:CGPointMake(0.f,_commandPanel.contentSize.height-_commandPanel.frame.size.height)];
}

- (void)clearSpeechCommandPanel {
    _commandPanel.text = @"";
}

- (IBAction)closeBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(closeBtnActionInVoiceVC:)]) {
        [_delegate closeBtnActionInVoiceVC:self];
    }
    if ([[_voiceBtn currentTitle] isEqualToString:@"Stop"]){
        [self stopVoiceDetection];
        [_voiceBtn setTitle:@"Start" forState:UIControlStateNormal];
    }
    
}

- (IBAction)voiceBtnAction:(id)sender {
    [self toggleVoiceDetection];
    if ([_delegate respondsToSelector:@selector(voiceBtnActionInVoiceVC:)]) {
        [_delegate voiceBtnActionInVoiceVC:self];
    }
}

#pragma speech kit
- (void) requestSpeechAuthorization {
    //TODO: add authorization of speech recognization
    // Initialize the Speech Recognizer with the locale, couldn't find a list of locales
    // but I assume it's standard UTF-8 https://wiki.archlinux.org/index.php/locale
    speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    // Set speech recognizer delegate
    speechRecognizer.delegate = self;
    
    // Request the authorization to make sure the user is asked for permission so you can
    // get an authorized response, also remember to change the .plist file, check the repo's
    // readme file or this projects info.plist
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"Not Determined");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            default:
                break;
        }
    }];
}

- (void)setupTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

// 监听开始与结束的方法
- (void)updateTimer {
    
    // 不更新就没法用了
    [self.monitor updateMeters];
    [self.monitor record];

    // 获得0声道的音量，完全没有声音-160.0，0是最大音量
    float power = [self.monitor peakPowerForChannel:0];

//            NSLog(@"%f", power);
    if (!self.recorder.isRecording) {
        NSLog(@"开始录音");
        [self.recorder record];
    }
    if (power > -20) {
        _t = 1;
//        NSLog(@"%f t = %d", power,_t);
    } else {
        if (self.recorder.isRecording) {
//            NSLog(@"%f recording t = %d", power,_t);
            if (_t == 1) {
            NSLog(@"停止录音");
            [self.recorder stop];
            [self recognition];
            _t = 0;
//            NSLog(@"%f t = %d", power,_t);
            }
        }
    }
}

- (void)recognition {
    // 时钟停止
    [self.timer invalidate];
    // 监听器也停止
    [self.monitor stop];
    // 删除监听器的录音文件
    [self.monitor deleteRecording];
    
    //创建语音识别操作类对象
//    speechRecognizer = [[SFSpeechRecognizer alloc]initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    //通过一个本地的音频文件来解析
    SFSpeechRecognitionRequest * request = [[SFSpeechURLRecognitionRequest alloc]initWithURL:_recordURL];
    [speechRecognizer recognitionTaskWithRequest:request delegate:self];
}

- (void) speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",recognitionResult.bestTranscription.formattedString);
    [self getVoiceCommand:[recognitionResult.bestTranscription.formattedString lowercaseString]];
    if (task.error) {
        NSLog(@"error~");
    }
//    [self setupTimer];
    [self toggleVoiceDetection];
}

- (void) speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully {
    NSLog(@"finished successful? %@",successfully?@"YES":@"NO");
    if (!successfully) {
        [self addSpeechCommand:@"didn't understand, please try again!"];
        [self stopVoiceDetection];
//        [self setupTimer];
        [self toggleVoiceDetection];
    }
}

- (void) toggleVoiceDetection {
    if ([[_voiceBtn currentTitle] isEqualToString:@"Start"]) { //start voice control
        [_voiceBtn setTitle:@"Stop" forState:UIControlStateNormal];
//        [self clearSpeechCommandPanel];
//        [self setupSpeechPanel];
        [self setupTimer];
    } else {
        [self stopVoiceDetection];
        [_voiceBtn setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (void) stopVoiceDetection {
    [audioEngine stop];
    [recognitionTask cancel];
    [self.timer invalidate];
    _temp = 0;
}

- (void) getVoiceCommand:(NSString *) temStr {
    [self.recogniseString setText:temStr];
    if ([temStr containsString:@"stop"]) {
        NSLog(@">>>voice command: stop mission");
        _speech = @">>>Stop mission \n";
        [self addSpeechCommand:_speech];
        if ([_delegate respondsToSelector:@selector(stopActionInVoiceVC:)]) {
            [_delegate stopActionInVoiceVC:self];
        }
        _mode = 0;
        return;
    }
    if ([temStr containsString:@"help"]) {
        NSLog(@"voice command help");
        _speech = @">>>voice command help \n";
        [self addSpeechCommand:_speech];
        [self setupSpeechPanel];
        _mode = 0;
        return;
    }
//    if ([temStr containsString:@"cancel"]) {
//        NSLog(@"voice command canceled");
//        _speech = @">>>voice command canceled \n";
//        [self addSpeechCommand:_speech];
//        [self setupSpeechPanel];
//        _mode = 0;
//        return;
//    }
    if ([_command containsString:@"execute"] && _mode == 3) {
        if ([temStr containsString:@"execute"]) {
            NSLog(@"---Executing Cleaning Mission---");
            _speech = @"---Executing Cleaning Mission--- \n";
            if ([_delegate respondsToSelector:@selector(cleaningExecuteActionInVoiceVC:)]) {
                [_delegate cleaningExecuteActionInVoiceVC:self];
            }
            _mode = 0;
            _command = @"";
            return;
        } else if ([temStr containsString:@"cancel"]) {
            NSLog(@">>>voice command configuration canceled!");
            _speech = @">>>voice command configuration canceled! \n";
            _command = @"";
            _mode = 0;
            return;
        }
        else {
            NSLog(@">>>Not a command!");
            _speech = @"Not a command! \n";
            return;
        }
    }
    if ([_command containsString:@"!"] && _mode == 2) {
        if ([_command containsString:@"cleaning"]) {
            if ([temStr containsString:@"vertical"]) {
//                [_cleaningC.mode.set];
                NSLog(@"---Setup Cleaning Vertical---");
                _speech = @"---Setup Cleaning Vertical--- \n speak 'execute' to start mission \n cleaning length & height is 3m, interval is 0.3m \n please make sure the drone is higher than 4m.";
                if ([_delegate respondsToSelector:@selector(cleaningVCommandActionInVoiceVC:)]) {
                    [_delegate cleaningVCommandActionInVoiceVC:self];
                }
                _mode = 3;
                _command = @"execute";
            }else if([temStr containsString:@"horizontal"]) {
                NSLog(@"---Setup cleaning horizontal---");
                _speech = @"---Setup cleaning horizontal--- \n speak 'execute' to start mission \n cleaning length & height is 3m, interval is 0.3m \n please make sure the drone is higher than 4m.";
                if ([_delegate respondsToSelector:@selector(cleaningHCommandActionInVoiceVC:)]) {
                    [_delegate cleaningHCommandActionInVoiceVC:self];
                }
                _mode = 3;
                _command = @"execute";
            } else if ([temStr containsString:@"cancel"]) {
                NSLog(@">>>voice command configuration canceled!");
                _speech = @">>>voice command configuration canceled! \n";
                _command = @"";
                _mode = 0;
            }
            else {
                NSLog(@">>>Not a command!");
                _speech = @"Not a command! \n";
            }
        }
        else if ([temStr containsString:@"ok"]) {
            NSLog(@">>>voice command congifuration accepted");
            _speech = @">>>voice command congifuration accepted \n";
            [self addSpeechCommand:_speech];
            if ([_command containsString:@"followme"]) {
                //TODO DJI follow me mission execute
                NSLog(@"---Executing follow me mission---");
                _speech = @"---Executing follow me mission--- \n";
                _mode = 0;
                _command = @"";
                if ([_delegate respondsToSelector:@selector(followmeActionInVoiceVC:)]) {
                    [_delegate followmeActionInVoiceVC:self];
                }
            } else if ([_command containsString:@"tolocation"]) {
                //TODO DJI to location mission execute
                NSLog(@"---Executing to location mission---");
                _speech = @"---Executing to location mission--- \n";
                _mode = 0;
                _command = @"";
                if ([_delegate respondsToSelector:@selector(tolocationActionInVoiceVC:)]) {
                    [_delegate tolocationActionInVoiceVC:self];
                }
            }
        } else if ([temStr containsString:@"cancel"]) {
            NSLog(@">>>voice command configuration canceled!");
            _speech = @">>>voice command configuration canceled! \n";
            _command = @"";
            _mode = 0;
        } else if ([temStr containsString:@"no"]) {
            NSLog(@">>>voice command configuration rejected! Please manual change configuration");
            _speech = @">>>voice command configuration rejected! Please manual change configuration! \n";
            if ([_delegate respondsToSelector:@selector(configActionInVoiceVC:)]) {
                [_delegate configActionInVoiceVC:self];
            }
            _command = @"";
            _mode = 0;
        } else {
            NSLog(@">>>Not a command!");
            _speech = @"Not a command! \n";
//            _mode = 0;
        }
        [self addSpeechCommand:_speech];
    } else if ([_command containsString:@"?"] && _mode == 1) {
        if ([temStr isEqualToString:@"yes"]) {
            NSLog(@"%@",_command);
            NSLog(@">>>Voice command confirmed.");
            _speech = @">>>Voice command confirmed. \n";
            [self addSpeechCommand:_speech];
            if (![_command containsString:@"!"]) {
                //execute command
                if ([_command containsString:@"take off"]) {\
                    NSLog(@"---auto take off mission confirmed---");
                    _speech = @"---take off mission confirmed--- \n";
//                    [_takeoffC executeTakeoff];
                    if ([_delegate respondsToSelector:@selector(takeoffActionInVoiceVC:)]) {
                        [_delegate takeoffActionInVoiceVC:self];
                    }
                } else if ([_command containsString:@"landing"]) {
                    NSLog(@"---executing auto landing mission---");
                    _speech = @"---executing auto landing mission--- \n";
//                    [_djiC onLandButtonClicked];
                    if ([_delegate respondsToSelector:@selector(landingActionInVoiceVC:)]) {
                        [_delegate landingActionInVoiceVC:self];
                    }
                } else if ([_command containsString:@"explore"]) {
                    NSLog(@"---executing explore mission---");
                    _speech = @"---executing explore mission--- \n";
                    if ([_delegate respondsToSelector:@selector(exploreActionInVoiceVC:)]) {
                        [_delegate exploreActionInVoiceVC:self];
                        //TODO
                    }
                }
                _mode = 0;
                _command = @"";
            } else {
                NSLog(@"%@",_command);
                NSString* t = [_command substringToIndex:[_command length]-1];
                _command = t;
                NSLog(@"%@",_command);
                //display command config
                if ([_command containsString:@"followme"]) {
                    //TODO display DJI follow me mission config
                    _speech = @">>>please accept or modify follow me command configuration: \n";
                    if ([_delegate respondsToSelector:@selector(followmeConfigInVoiceVC:)]) {
                        [_delegate followmeConfigInVoiceVC:self];
                    }
                    _mode = 2;
                } else if ([_command containsString:@"tolocation"]) {
                    //TODO display DJI to location mission config
                    _speech = @">>>please accept or modify to location command configuration: \n";
                    _speech = [_speech stringByAppendingString:@"altitude: 16m \n"];
                    _speech = [_speech stringByAppendingString:@"speed: 3m/s \n"];
                    _mode = 2;
                } else if ([_command containsString:@"cleaning"]) {
                    _speech = @">>>please speak cleaning method(vertical/horizonal): \n";
                    _mode = 2;
                }
                NSLog(@"%@",_command);
            }
            NSLog(@"%@",_command);
        } else if ([temStr isEqualToString:@"no"]) {
            NSLog(@">>>Command rejected!");
            _speech = @">>>Command rejected! \n";
            _command = @"";
            _mode = 0;
        } else {
            NSLog(@">>>Not a command!");
            _speech = @"Not a command! \n";
//            _mode = 0;
        }
        NSLog(@"%@",_command);
        [self addSpeechCommand:_speech];
    } else if ([@"" isEqualToString: _command] && _mode == 0) { //root commands
        if ([temStr containsString:@"take off"]) {
            NSLog(@">>>voice command: take off?(yes/no)");
            _speech = @">>>voice command: take off?(yes/no) \n";
            _speech = [_speech stringByAppendingString:@"Ensure that conditions are safe for takeoff. The aircraft will climb to an altitude of 4 ft. and hover in place."];
            _speech = [_speech stringByAppendingString:@"\n"];
            _command = @"take off?";
            _mode = 1;
        } else if ([temStr containsString:@"landing"]){
            NSLog(@">>>voice command: landing?(yes/no)");
            _speech = @">>>voice command: landing?(yes/no) \n";
            _command = @"landing?";
            _mode = 1;
        } else if ([temStr containsString:@"follow me"]){
            NSLog(@">>>voice command: follow me?(yes/no)");
            _speech = @">>>voice command: follow me?(yes/no) \n";
            _command = @"followme!?";
            _mode = 1;
        } else if ([temStr containsString:@"to location"]){
            NSLog(@">>>voice command: to location?(yes/no)");
            _speech = @">>>voice command: to location?(yes/no) \n";
            _command = @"tolocation!?";
            _mode = 1;
        } else if ([temStr containsString:@"explore"]){
            NSLog(@">>>voice command: explore?(yes/no)");
            _speech = @">>>voice command: explore?(yes/no) \n";
            _command = @"explore?";
            _mode = 1;
        } else if ([temStr containsString:@"clean"]){
            NSLog(@">>>voice command: cleaning?(yes/no)");
            _speech = @">>>voice command: cleaning?(yes/no) \n";
            _command = @"cleaning!?";
            _mode = 1;
        } else {
            NSLog(@">>>Not a command!!!");
            _speech = @"Not a command! \n";
//            _mode = 0;
        }
        [self addSpeechCommand:_speech];
    } else {
        NSLog(@">>>Not a command!");
        _speech = @"Not a command! \n";
        [self addSpeechCommand:_speech];
//        _mode = 0;
    }
    NSLog(@"%@",_command);
    [self addSpeechCommand:@"\n"];
}

@end
