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
#import <FBSDKCoreKit/FBSDKAccessToken.h>


#define ACCESS_TOKEN_KEY @"fb_access_token"
#define EXPIRATION_DATE_KEY @"fb_expiration_date"

@interface ViewController ()
//@property BOOL isLogined;
@property (strong, nonatomic) NSString *userIDtoSaveOK;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // 改變Token,進入下個View.
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
             }
         }];
    }
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        // TODO: publish content.
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            //TODO: process error or result.
            if (!error) {
                NSLog(@"publish_actions = fetched user:%@", result);
            }
        }];
    }
    
    self.userIDtoSaveOK = [[NSString alloc] initWithString:[FBSDKAccessToken currentAccessToken].userID];
    NSLog(@"user id to sava == %@", self.userIDtoSaveOK);
//    NSLog(@"%@, %@, %@", [FBSDKAccessToken currentAccessToken].tokenString, [FBSDKAccessToken currentAccessToken].appID, [FBSDKAccessToken currentAccessToken].permissions);
    if (self.userIDtoSaveOK != nil) {
        NSLog(@"UserID present OK");
        [self presentVC];
    }

    /*
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"public_profile"]) {
                NSLog(@"##### AccessToken public_profile OK #####");
                [self presentVC];
            }else {
        
                FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
                [login logInWithReadPermissions:@[@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                    if (error) {
                        NSLog(@"##### AccessToken error #####");
                    }else if (result.isCancelled) {
                        NSLog(@"##### AccessToken isCancelled #####");
                    }else {
                        NSLog(@"##### AccessToken OK 2 #####");
                        [self presentVC];
                    }
                }];
             
            }
    */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fbTokenChangeNoti:)
                                                 name:FBSDKAccessTokenDidChangeNotification object:nil];
    
    [self background];
    [self fbLoginButton];
}


- (IBAction)testButton:(id)sender {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MapView"] animated:YES completion:nil];
}


// Get FB token to present next view.
- (void)fbTokenChangeNoti:(NSNotification*)noti {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"##### Login Successed #####");
        [self presentVC];
    }
}

- (void)presentVC {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MapView"] animated:YES completion:nil];
}

- (void)fbLoginButton {
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = CGPointMake(self.view.center.x-100, -480);
    [self.view addSubview:loginButton];
}
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
