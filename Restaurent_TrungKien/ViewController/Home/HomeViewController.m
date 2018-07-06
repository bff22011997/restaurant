//
//  HomeViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/25/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "HomeViewController.h"
#import "CollectionViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Common.h"
#import "Table.h"
#import "FoodViewController.h"
#import "Global.h"
#import "Ulti.h"
#import "AppDelegate.h"
#import "SVPullToRefresh.h"
#import "SWRevealViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController {
    NSMutableArray *arrTable;
    NSMutableArray *arrTableAddData;
    int i;
    int check;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrTable = [[NSMutableArray alloc]init];
    arrTableAddData = [[NSMutableArray alloc]init];
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [self insertRowAtTop];
    }];
    
        [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [self insertRowAtBottom];
    }];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    _collectionView.refreshControl = refreshControl;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark load more + refresh
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    if( _collectionView.refreshControl.isRefreshing )
        [self refresh];
}
- (void)refresh
{
    [_collectionView.refreshControl endRefreshing];
    
    
    [self.collectionView reloadData];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
    [self getDataFromAPI];
    
}
- (void)insertRowAtTop {
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        check = 0;
        [self getDataFromAPI];
        [self.collectionView.infiniteScrollingView stopAnimating];
    });
}


- (void)insertRowAtBottom {
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        check = 1;
        [self getDataFromAPI];
        [self.collectionView.infiniteScrollingView stopAnimating];
    });
}
#pragma mark Get data
-(void) getDataFromAPI {
    [arrTable removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ALL_TABLES];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray* arrResponseObjects = [responseObject objectForKey:@"data"];
       
        for (NSDictionary *object in arrResponseObjects) {
            Table *tb = [[Table alloc]init];
            tb.tableID = [object objectForKey:@"id"];
            tb.tableOperatorId = [object objectForKey:@"operatorId"];
            tb.tableStatus = [object objectForKey:@"status"];
            [arrTable addObject:tb];
        }
        [Ulti saveArrayObjectToNSUserDefault:arrTable forkey:@"table"];
        if (check == 0) {
            [arrTableAddData removeAllObjects];
        }
        for (int j=0; j<arrTable.count; j++) {
            Table *t = [arrTable objectAtIndex:j];
            [arrTableAddData addObject:t];
        }
        [self.collectionView.refreshControl endRefreshing];
        [_collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:(YES)];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}
#pragma mark Logout
- (IBAction)onBack:(id)sender {
    [self.revealViewController revealToggleAnimated:true];
    
}
#pragma mark CollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrTableAddData.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width-60)/3,(collectionView.frame.size.width-60)/3-20);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    Table *tb = [arrTableAddData objectAtIndex:indexPath.row];
    cell.lblNameTable.text = tb.tableID;
    if ([tb.tableStatus intValue] == 2) {
        cell.imageTable.image = [UIImage imageNamed:@"table_not_select.png"];
        cell.lblNameTable.textColor = [UIColor lightGrayColor];
    }
    else {
        cell.imageTable.image = [UIImage imageNamed:@"table_select.png"];
        cell.lblNameTable.textColor = [UIColor redColor];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Table *tb = [arrTableAddData objectAtIndex:indexPath.row];
    FoodViewController *food = [[FoodViewController alloc]init];
    food.tableNumber = tb.tableID;
    [self.navigationController pushViewController:food animated:true];
}
#pragma mark Refreash
- (IBAction)onRefresh:(id)sender {
    [self getDataFromAPI];
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
