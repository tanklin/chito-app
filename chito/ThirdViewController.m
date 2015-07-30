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
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rootView = self.navigationController.view;
    [self showIntroWithCrossDissolve];
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
    
    [intro showInView:rootView animateDuration:0.5];
}

@end
