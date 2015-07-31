//
//  VisitTableViewCell.h
//  CHiTO
//
//  Created by Tank Lin on 2015/7/29.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitTableViewCell : UITableViewCell
@property (atomic, weak) IBOutlet UIImageView *shopImag;
@property (atomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
