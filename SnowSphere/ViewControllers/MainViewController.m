//
//  MainViewController.m
//  SnowSphere
//
//  Created by Csorba Mátyás on 12/12/14.
//  Copyright (c) 2014 Csorba Mátyás. All rights reserved.
//

#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "snowView.h"

@interface MainViewController ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation MainViewController {
    snowView *snowOverlay;
}



- (BOOL)canBecomeFirstResponder{
    
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self playSound];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSError *error;
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:@"christmas-bells" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AVAudioPlayer *theAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [theAudioPlayer prepareToPlay];
    self.audioPlayer = theAudioPlayer;
    
    
    snowOverlay = [[snowView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:snowOverlay];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)playSound
{
    [self.audioPlayer play];
    [snowOverlay beginSnowAnimation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
