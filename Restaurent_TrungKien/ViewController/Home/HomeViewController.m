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
    NSMutableArray *arrTableDevide;
    int i;
    int check;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrTable = [[NSMutableArray alloc]init];
    arrTableDevide = [[NSMutableArray alloc]init];
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [self insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [self insertRowAtBottom];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    //i = (int)arrTable.count/2 + 6;
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
        i++;
        [self getDataFromAPI];
        [self.collectionView.infiniteScrollingView stopAnimating];
    });
}
#pragma mark Get data
-(void) getDataFromAPI {
   
    [arrTableDevide removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ALL_TABLES];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray* arrResponseObjects = [responseObject objectForKey:@"data"];
        [arrTable removeAllObjects];
        for (NSDictionary *object in arrResponseObjects) {
            Table *tb = [[Table alloc]init];
            tb.tableID = [object objectForKey:@"id"];
            tb.tableOperatorId = [object objectForKey:@"operatorId"];
            tb.tableStatus = [object objectForKey:@"status"];
            [arrTable addObject:tb];
        }
        [Ulti saveArrayObjectToNSUserDefault:arrTable forkey:@"table"];
        if (check == 0) {
            i = (int)arrTable.count/2 + 6;
        } else {
            
        }
        
        for (int j=0; j<=i; j++) {
            Table *t = [arrTable objectAtIndex:j];
            [arrTableDevide addObject:t];
        }
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
    return arrTableDevide.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width-60)/3,(collectionView.frame.size.width-60)/3-20);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    Table *tb = [arrTableDevide objectAtIndex:indexPath.row];
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
    Table *tb = [arrTableDevide objectAtIndex:indexPath.row];
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
