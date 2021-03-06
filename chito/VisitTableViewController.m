//
//  VisitTableViewController.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/28.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "VisitTableViewController.h"
#import "MBProgressHUD.h"
#import "GV.h"
#import <AFNetworking.h>
#import <SIAlertView/SIAlertView.h>

@interface VisitTableViewController ()
{
    NSArray *json;
    NSMutableArray *jsonDataMutableArray;
    NSDictionary *dataDictionaryFromArrayJson;
    NSMutableString *titleData;
    NSMutableString *telData;
    NSMutableString *addressData;

    NSString *tel;
}
@property (weak, nonatomic) NSArray *visitArray;
@end

@implementation VisitTableViewController
//static NSString *visitTableViewCellIdentifier = @"visitCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最近瀏覽";
    [self progressHUD];
    [self loadVisitRestaurant];
    [self reloadTableView];
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor blackColor]];
    [bar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:111.0/255.0 blue:28.0/255.0 alpha:1]];
    [bar setTranslucent:NO];

}

- (void)reloadTableView
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tbView addSubview:self.refreshControl]; //把RefreshControl加到TableView中
}
- (void)refresh{
    [self.tbView reloadData];
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

- (void)loadVisitRestaurant //visit_git
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [manager POST:kVisit_get parameters:@{
                                         @"auth_token":[defaults stringForKey:kAuth_token],
                                         @"user_id":[defaults stringForKey:kUser_id]
                                         }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSData *visitData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
             json = [NSJSONSerialization JSONObjectWithData:visitData options:NSJSONReadingMutableContainers error:nil];

             NSLog(@"=== Post Visit response === %@", json);

             NSDictionary *dicJson = (NSDictionary*)json;
             jsonDataMutableArray = [NSMutableArray new];

             for (NSDictionary *dataDict in dicJson[@"data"]) {
//                 telData = [dataDict objectForKey:@"name"];
//                 telData = [dataDict objectForKey:@"tel"];
//                 addressData = [dataDict objectForKey:@"address"];

//                 NSLog(@"Name: %@", titleData);
//                 NSLog(@"Tel: %@", telData);
//                 NSLog(@"Address: %@", addressData);

                 [jsonDataMutableArray addObject:dataDict];

//                 dataDictionaryFromArrayJson = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                titleData, @"name",
//                                                telData, @"tel",
//                                                addressData, @"address",
//                                                nil];
//                 NSLog(@"dataDictionaryFromArrayJson %@", dataDictionaryFromArrayJson);
//                 [jsonDataMutableArray addObject:dataDictionaryFromArrayJson];
                 NSLog(@"jsonDataMutableArray:: %@", jsonDataMutableArray);
                 NSLog(@"=== json count \"%ld\" ===",jsonDataMutableArray.count);

                 [self.tableView reloadData];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"=== Post Visit failure === %@", error);
     }];
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;

    switch (section) {
        case 0:
            header = @"最近瀏覽的餐廳";
            break;

        default:
            break;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [jsonDataMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary *tmpDict = [jsonDataMutableArray objectAtIndex:indexPath.row];
    titleData = [NSMutableString stringWithFormat:@"%@", [tmpDict objectForKey:@"name"]];
    telData = [NSMutableString stringWithFormat:@"%@", [tmpDict objectForKey:@"tel"]];
    addressData = [NSMutableString stringWithFormat:@"%@", [tmpDict objectForKey:@"address"]];

    UILabel *titleLabel = (UILabel*)[cell viewWithTag:100];
    titleLabel.text = titleData;
    NSLog(@"$$$ Name %@", titleLabel.text);

    UILabel *telLabel = (UILabel*)[cell viewWithTag:200];
    telLabel.text = telData;
    NSLog(@"$$$ Tel %@", telLabel.text);

    UILabel *addressLabel = (UILabel*)[cell viewWithTag:300];
    addressLabel.text = addressData;
    NSLog(@"$$$ Address %@", addressLabel.text);

    return cell;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tel = [NSString stringWithFormat:@"%@", telData];

    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:titleData
                                                     andMessage:tel];
    [alertView addButtonWithTitle:@"撥打電話"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [self callServices];
                              NSLog(@"Call Button Clicked");
                          }];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Cancel Button Clicked");
                          }];

    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };

    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;

    [alertView show];
}

- (void)callServices
{
    NSString *temp = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *phoneURL = [NSString stringWithFormat:@"tel://%@", temp];
    NSLog(@"Call %@", phoneURL);
    BOOL ifCall = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
    if (!ifCall) {
        NSLog(@"calling error");
    }
}

- (void)progressHUD
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
