//
//  ChristmasViewController.m
//  SnowSphere
//
//  Created by Csorba Mátyás on 14/12/14.
//  Copyright (c) 2014 Csorba Mátyás. All rights reserved.
//

#import "ChristmasViewController.h"
#import "snowView.h"


@interface ChristmasViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *frontCamera;
@property (nonatomic, strong) AVCaptureDeviceInput *backCamera;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic) BOOL isFront;

@property (weak, nonatomic) IBOutlet UIView *cameraControllView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *switchingTheCamera;

@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, strong) UIImageView *imageView;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


@end

@implementation ChristmasViewController{
    int take;
    snowView *snowOverlay;
}

#pragma mark -
#pragma mark VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.switchingTheCamera addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    [self.actionButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    
    NSError *error;
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:@"christmas-bells" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AVAudioPlayer *theAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [theAudioPlayer prepareToPlay];
    self.audioPlayer = theAudioPlayer;
    snowOverlay = [[snowView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:snowOverlay];
    
    [self startCamera];
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

- (BOOL)canBecomeFirstResponder{
    
    return YES;
}

#pragma mark -
#pragma mark Camera Functions

-(BOOL)startCamera
{
    NSLog(@"nyitom a kamerat");
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    //kamera device keresese
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                backCamera = device;
            }
            else {
                frontCamera = device;
            }
        }
    }
    
    _backCamera = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
    _frontCamera = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:nil];
    
    _isFront = NO;
    
    _captureSession = [[AVCaptureSession alloc]init];
    [_captureSession addInput:_backCamera];
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_previewLayer setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    NSLog(@"szelesseg %f magassag %f", _previewLayer.frame.size.width , _previewLayer.frame.size.height);
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    [_captureSession addOutput:_stillImageOutput];
    
    [_captureSession startRunning];
    
    
    return YES;
}

#pragma mark -
#pragma mark Switch camera

-(void)switchCamera
{
    if (!_isFront) {
        [_captureSession removeInput:_backCamera];
        [_captureSession addInput:_frontCamera];
        _isFront = YES;
    } else {
        [_captureSession removeInput:_frontCamera];
        [_captureSession addInput:_backCamera];
        _isFront = NO;
    }
}

-(void)takePicture
{
    
    NSLog(@"kep keszitese..");
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    NSLog(@"%@", videoConnection);
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        NSLog(@"error = %@", error);
        if (CMSampleBufferIsValid(imageSampleBuffer)) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            self.picture = [[UIImage alloc] initWithData:imageData];
            
            if ([self.delegate respondsToSelector:@selector(isPictureTaken:)])
            {
                [self.delegate isPictureTaken:_picture];
            }
            [_captureSession stopRunning];
            [self.previewLayer removeFromSuperlayer];
            
            
            if (_isFront) {
                UIImage * flippedImage = [UIImage imageWithCGImage:_picture.CGImage scale:_picture.scale    orientation:UIImageOrientationLeftMirrored];
                _picture = flippedImage;
            }
            
            self.imageView.image = self.picture;
            [self.cameraControllView removeFromSuperview];
            [self.view insertSubview:self.imageView atIndex:0];
            
           
            [self stopCamera];
            take = 1;
            
        } else {
            return;
        }
        
    }];
    
    
    
}

-(void)stopCamera
{
    [_captureSession stopRunning];
    
    UIButton *back2 = [[UIButton alloc]initWithFrame:CGRectMake(20, [[UIScreen mainScreen]bounds].size.height-30, 40, 20)];
    back2.titleLabel.text = @"Vissza";
    back2.titleLabel.textColor = [UIColor whiteColor];
    back2.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    [back2 addTarget:self action:@selector(back2Main) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:back2];
    
}

#pragma mark -
#pragma mark Animation

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self playSound];
    }
}


-(IBAction)playSound
{
    [self.audioPlayer play];
    [snowOverlay beginSnowAnimation];
}
#pragma mark -
#pragma mark Navigation

- (IBAction)backToMain:(id)sender {
    [self.previewLayer removeFromSuperlayer];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)back2Main{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
