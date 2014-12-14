//
//  ChristmasViewController.h
//  SnowSphere
//
//  Created by Csorba Mátyás on 14/12/14.
//  Copyright (c) 2014 Csorba Mátyás. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol MyCameraControllDelegate;

@interface ChristmasViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic)id<MyCameraControllDelegate>delegate;
@property (nonatomic, strong) UIImage *theImage;


-(BOOL)startCamera;
-(void)switchCamera;
-(void)takePicture;

@end

@protocol MyCameraControllDelegate <NSObject>

@optional
-(void)isPictureTaken:(UIImage *)picture;

@end