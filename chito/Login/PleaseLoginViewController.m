//
//  PleaseLoginViewController.m
//  chito
//
//  Created by Tank Lin on 2015/7/17.
//  Copyright © 2015年 CHiTO. All rights reserved.
//

#import "PleaseLoginViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface PleaseLoginViewController ()

@end

@implementation PleaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Login_bg_why"] drawInRect:self.view.bounds];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}
- (IBAction)btnDidPressedYes:(id)sender {
//    [self.delegate btnDidPressedYes.self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
