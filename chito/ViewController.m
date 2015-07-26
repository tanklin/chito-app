//
//  ViewController.m
//  chito
//
//  Created by Tank Lin on 2015/7/13.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface ViewController ()
{
    UIView *rootView;
    EAIntroView *_intro;
}

//@property BOOL isFirstTimeLaunchApp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isFirstTimeLaunchApp = YES;
    /// intro rootview
    rootView = self.navigationController.view;

//    if (self.isFirstTimeLaunchApp) {
//        [self showIntroWithCrossDissolve];
//        self.isFirstTimeLaunchApp = NO;
//        NSLog(self.isFirstTimeLaunchApp ? @"YES" : @"NO");
//    }

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"]) {
        [[NSUserDefaults standardUserDefaults] synchronize];
        //Action here
        [self showIntroWithCrossDissolve];
    }
    // 改變Token,進入下個View.
    
    /*
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
     */

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

    [self fbLoginButton];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fbTokenChangeNoti:)
                                                 name:FBSDKAccessTokenDidChangeNotification object:nil];

    [self background];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([FBSDKAccessToken currentAccessToken]) {
        [self presentVC];
    }
}


/// 測試用
- (IBAction)testButton:(id)sender {
//    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MapView"] animated:YES completion:nil];
    NSLog(@"### Test Button ###");
}
- (IBAction)fbLoginButtonDidPressed:(UIButton *)sender {
    NSLog(@"### FB Login Button Did Pressed ###");
}


/// Get FB token to present next view.
- (void)fbTokenChangeNoti:(NSNotification*)noti {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"##### Login Successed #####");
        [self presentVC];
    }
}

- (void)presentVC {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"navView"] animated:YES completion:nil];
    [ViewController dealloc];
}

- (void)fbLoginButton {
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = CGPointMake(self.view.center.x-100, -100);
    [self.view addSubview:loginButton];
}

- (void)background {
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Login_bg"] drawInRect:self.view.bounds];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

/// Intro View
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];

    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];

    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];

    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];

    [intro showInView:rootView animateDuration:0.5];
}

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end
