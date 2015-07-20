//
//  CustomInfoWindow.h
//  CHiTO
//
//  Created by Tank Lin on 2015/7/20.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInfoWindow : UIView
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopTel;
@property (weak, nonatomic) IBOutlet UILabel *shopAddress;

@end
