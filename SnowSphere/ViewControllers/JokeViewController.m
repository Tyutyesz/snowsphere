//
//  JokeViewController.m
//  SnowSphere
//
//  Created by Csorba Mátyás on 14/12/14.
//  Copyright (c) 2014 Csorba Mátyás. All rights reserved.
//

#import "JokeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface JokeViewController ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation JokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSError *error;
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:@"Ba-dum-tss" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AVAudioPlayer *theAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [theAudioPlayer prepareToPlay];
    self.audioPlayer = theAudioPlayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)laughButton:(id)sender {
    [self.audioPlayer play];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
