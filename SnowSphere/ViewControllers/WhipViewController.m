//
//  WhipViewController.m
//  SnowSphere
//
//  Created by Csorba Mátyás on 14/12/14.
//  Copyright (c) 2014 Csorba Mátyás. All rights reserved.
//

#import "WhipViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WhipViewController ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


@end

@implementation WhipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSError *error;
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:@"WhipCrack-Short" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AVAudioPlayer *theAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [theAudioPlayer prepareToPlay];
    self.audioPlayer = theAudioPlayer;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction)playSound
{
    [self.audioPlayer play];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




@end
