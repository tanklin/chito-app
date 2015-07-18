//
//  ViewController.m
//  chito
//
//  Created by Tank Lin on 2015/7/13.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController ()
//@property BOOL isLogined;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fbLoginButton];
    [self background];
    
    // 第一次Login成功,進入下個View.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fbTokenChangeNoti:)
                                                 name:FBSDKAccessTokenDidChangeNotification object:nil];
    
//    if (!_isLogined) {
//        [FBSDKAccessToken currentAccessToken];
//        [self presentVC];
//        NSLog(@"##### AccessToken OK #####");
//    }else {
//        NSLog(@"##### AccessToken not OK #####");
//    }
//    _isLogined = !_isLogined;

    
    // 判斷是否Login狀態,if Yes進入下個View.
//    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"public_profile"]) {
//        NSLog(@"##### AccessToken OK #####");
//        [self presentVC];
//
//    }else {
//        
//        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        [login logInWithReadPermissions:@[@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//            if (error) {
//                NSLog(@"##### AccessToken error #####");
//            }else if (result.isCancelled) {
//                NSLog(@"##### AccessToken isCancelled #####");
//            }else {
//                NSLog(@"##### AccessToken OK 2 #####");
//                [self presentVC];
//            }
//        }];
//     
//    }
    
}



// Get FB token to present next view.
- (void)fbTokenChangeNoti:(NSNotification*)noti {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"##### Login Successed #####");
        [self presentVC];
    }
}

- (void)presentVC {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NextViewController"] animated:YES completion:nil];
}

- (void)fbLoginButton {
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = CGPointMake(self.view.center.x-100, -480);
    [self.view addSubview:loginButton];
}

// Background Image
- (void)background {
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Login_bg"] drawInRect:self.view.bounds];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
