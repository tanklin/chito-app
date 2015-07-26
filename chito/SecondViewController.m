//
//  SecondViewController.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/24.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "SecondViewController.h"
#import "RightViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = @"http://www.chito.city";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webChito loadRequest:urlRequest];

    UIImage *img = [UIImage imageNamed:@"logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [imgView setImage:img];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
}
//
//#pragma mark -
//#pragma mark RESideMenu Delegate
//
//- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
//{
//    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
//}
//
//- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
//{
//    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
//}
//
//- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
//{
//    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
//}
//
//- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
//{
//    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
//}

@end
