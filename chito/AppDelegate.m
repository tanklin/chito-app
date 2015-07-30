//
//  AppDelegate.m
//  chito
//
//  Created by Tank Lin on 2015/7/13.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface AppDelegate ()
@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [FBSDKLoginButton class];

    [GMSServices provideAPIKey:@"AIzaSyC7ztLan0fjcgHcUwbAX3jplG_vq0cbd-k"];

    // check if user is logged in and had a token
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"]) {
        UIViewController *firstVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
        self.window.rootViewController = firstVC;
    }
    /*
    NSLog(@"Default : I got user id == %@", [FBSDKAccessToken currentAccessToken].userID);
    if ([FBSDKAccessToken currentAccessToken].userID == nil) {
        NSLog(@"I got user id == %@", [FBSDKAccessToken currentAccessToken].userID);

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    }else {
        NSLog(@"esle: I got user id == %@", [FBSDKAccessToken currentAccessToken].userID);
    }
    
    if ([FBSDKAccessToken currentAccessToken] == nil) {
        NSLog(@"123");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    }
     */


    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

/*
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"### token ### %@", token);
}
*/

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
