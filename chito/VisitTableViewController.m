//
//  VisitTableViewController.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/28.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "VisitTableViewController.h"
#import "GV.h"
#import <AFNetworking.h>

@interface VisitTableViewController ()
{
    NSArray *json;
    NSMutableArray *jsonDataMutableArray;
    NSDictionary *dataDictionaryFromArrayJson;
    NSMutableString *titleData;
    NSMutableString *telData;
    NSMutableString *addressData;
}
@property (weak, nonatomic) NSArray *visitArray;
@end

@implementation VisitTableViewController
//static NSString *visitTableViewCellIdentifier = @"visitCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadVisitRestaurant];
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor blackColor]];
    [bar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:111.0/255.0 blue:28.0/255.0 alpha:1]];
    [bar setTranslucent:NO];
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

    NSLog(@"%@", jsonDataMutableArray);
    NSDictionary *tmpDict = [jsonDataMutableArray objectAtIndex:indexPath.row];
    NSLog(@"Temp Dict: %@", tmpDict);

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


//    cell.textLabel.text = @"Name";
//    cell.imageView.image = [UIImage imageNamed:@"title1.png"];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
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
