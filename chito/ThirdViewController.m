//
//  ThirdViewController.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/26.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()
{
    UIView *rootView;
    EAIntroView *_intro;
}
@property (nonatomic, strong) UIButton *skipButton;
@end

@implementation ThirdViewController

@synthesize skipButton = _skipButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    rootView = self.navigationController.view;
    [self showIntroWithCrossDissolve];
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
- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [[UIButton alloc] init];
        [_skipButton setTitle:NSLocalizedString(@" ", nil) forState:UIControlStateNormal];
        [self applyDefaultsToSkipButton];
    }
    return _skipButton;
}

- (void)applyDefaultsToSkipButton {
    _skipButton.translatesAutoresizingMaskIntoConstraints = YES;
//    [_skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
}
@end
