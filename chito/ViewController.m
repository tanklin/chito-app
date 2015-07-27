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
#import <AFNetworking.h>

#define loginURL_ @"http://www.chito.city/api/v1/login"

@interface ViewController ()
{
    UIView *rootView;
    EAIntroView *_intro;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /// Tutorial rootview
    rootView = self.navigationController.view;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"]) {
        [[NSUserDefaults standardUserDefaults] synchronize];
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

    //[self fbLoginButton];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fbTokenChangeNoti:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];

    [self background];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([FBSDKAccessToken currentAccessToken]) {
        [self postToken];
        [self presentVC];
    }
}

- (void)postToken
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"access_token":[FBSDKAccessToken currentAccessToken].tokenString};
    [manager POST:loginURL_ parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"auth_token"] forKey:@"auto_token"];
              [[NSUserDefaults standardUserDefaults] synchronize];
              NSLog(@"=== Post token OK === %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"=== Post token Error === %@", error);
          }];
}


/// Tutorial finished
- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
}



/// 測試用
- (IBAction)testButton:(id)sender {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"rootController"] animated:YES completion:nil];
    NSLog(@"### Test Button ###");
}
- (IBAction)fbLoginButtonDidPressed:(UIButton *)sender {
    NSLog(@"### FB Login Button Did Pressed ###");
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // get Facebook graphic data
//                if ([FBSDKAccessToken currentAccessToken]) {
//                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
//                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                         if (!error) {
//                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                             [defaults setObject:result[kFbGiveID] forKey:@"fbID"];
//                             [defaults setObject:result[kFbGiveGender] forKey:kFbGiveGender];
//
//                             //NSLog(@"%@", result);
//                         }
//                     }];
//                }

                // Let fbTokenChangeNoti to do following things
            }
        }
    }];
}


/// Get FB Token to present next view.
- (void)fbTokenChangeNoti:(NSNotification*)noti {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"##### Login Successed #####");
        [self postToken];
        [self presentVC];
    }
}

- (void)presentVC {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"rootController"] animated:YES completion:nil];
//    [ViewController dealloc];hb
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
    page1.title = @"點 3 下，就決定吃什麼！";
    page1.desc = @"不需要搜尋、不需要篩選、不需要白跑，我們也都曾體會過，所以「CHiTO」誕生了";
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];

    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"第1步：點一個「心情」";
    page2.desc = @"想吃什麼，看心情就對了！最熱門，最簡單的美食店家都幫你準備好了，只管告訴CHiTO你想的是什麼，剩下的CHiTO幫你搞定！";
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];

    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"第2步：挑一個「心儀」";
    page3.desc = @"簡單明瞭的店家資訊，距離、位置，一目了然，挑一個最「中意」的，就是這麼簡單！";
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];

    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"第3步：懂你的「心急」";
    page4.desc = @"餐廳就在一「鍵」之遙，一鍵撥號讓你馬上訂位！CHiTO帶著你走，連走路都能導航！";
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iPhone6"]];
    intro.titleView = titleView;
    intro.titleViewY = 50;

    [intro showInView:rootView animateDuration:0.5];}



//- (void)viewWillAppear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [super viewWillAppear:animated];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [super viewWillDisappear:animated];
//}

@end
