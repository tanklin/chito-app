//
//  SecondViewController.h
//  CHiTO
//
//  Created by Tank Lin on 2015/7/24.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheSidebarController.h"

@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webChito;
@property (strong, nonatomic) UIBarButtonItem *rightButton;
@end
