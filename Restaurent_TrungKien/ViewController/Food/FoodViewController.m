//
//  FoodViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/25/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "FoodViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "FoodTableViewCell.h"
#import "Food.h"
#import "Common.h"
#import "Ulti.h"
#import "CategoryViewController.h"
#import "CatViewController.h"
#import "SVPullToRefresh.h"


@interface FoodViewController ()

@end

@implementation FoodViewController {
    NSMutableArray *arrFood;
    NSMutableArray *arrFoodDevice;
    int i;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrFoodDevice = [[NSMutableArray alloc]init];
    arrFood = [[NSMutableArray alloc]init];
    [_tblView registerNib:[UINib nibWithNibName:@"FoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoodTableViewCell"];
    _lblTitle.text = [NSString stringWithFormat:@"Table %@",_tableNumber];
    [self.tblView addPullToRefreshWithActionHandler:^{
        [self insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [self.tblView addInfiniteScrollingWithActionHandler:^{
        [self insertRowAtBottom];
    }];
    // Do any additional setup after loading the view from its nib.
}
- (void)insertRowAtTop {
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        i = 0;
        [arrFoodDevice removeAllObjects];
        Food *f = [arrFood objectAtIndex:0];
        [arrFoodDevice addObject:f];
        [_tblView reloadData];
        [self.tblView.infiniteScrollingView stopAnimating];
    });
}


- (void)insertRowAtBottom {

    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        i++;
        [self getDataFromAPI];
        [self.tblView.infiniteScrollingView stopAnimating];
    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [self getDataFromAPI];
   
}
- (void)viewDidAppear:(BOOL)animated {
    
}
#pragma mark Get data
-(void) getDataFromAPI {
    
    [arrFoodDevice removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,CATEGORY];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *arrDataRespone = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in arrDataRespone) {
            Food *food = [[Food alloc]init];
            food.foodID = [dic objectForKey:@"id"];
            food.foodImage = [dic objectForKey:@"imageUrl"];
            food.foodName = [dic objectForKey:@"name"];
            [arrFood addObject:food];
        }
        [Ulti removeObjectForKey:ARR_CATEGORY_SAVE_KEY];
        [Ulti saveArrayObjectToNSUserDefault:arrFood forkey:ARR_CATEGORY_SAVE_KEY];
        NSArray *arrFoodSelected= [[NSArray alloc]init];
        [Ulti saveArrayObjectToNSUserDefault:arrFoodSelected forkey:ARR_FOOD_SELECTED_SAVE_KEY];
        for (int j=0; j<=i; j++) {
            Food *f = [arrFood objectAtIndex:j];
            [arrFoodDevice addObject:f];
        }
        [_tblView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}
#pragma Table View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrFoodDevice.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (100 - tableView.bounds.size.height/8)?100:tableView.bounds.size.height/8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Food *food = [arrFoodDevice objectAtIndex:indexPath.row];
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSURL *url = [NSURL URLWithString:food.foodImage];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.imageFood.image = [UIImage imageWithData:data];
    cell.lblNameFood.text = food.foodName;
    cell.line.hidden = NO;
    if (indexPath.row == arrFood.count-1) {
        cell.line.hidden = YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Food *food = [arrFoodDevice objectAtIndex:indexPath.row];
    CategoryViewController *cat = [[CategoryViewController alloc]init];
    cat.idCategory = food.foodID;
    cat.tableNumber = _tableNumber;
    cat.arrFoodImage = arrFood;
    cat.indexImage = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [self.navigationController pushViewController:cat animated:true];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark Cart
- (IBAction)onCart:(id)sender {
    CatViewController *cartVC = [[CatViewController alloc]init];
    cartVC.tableId =_tableNumber;
    [self.navigationController pushViewController:cartVC animated:YES];
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
