//
//  VisitTableViewController.h
//  CHiTO
//
//  Created by Tank Lin on 2015/7/28.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitTableViewController : UITableViewController
@property (nonatomic, strong) IBOutlet UITableView * tbView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end
