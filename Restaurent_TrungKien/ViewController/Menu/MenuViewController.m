//
//  MenuViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 7/5/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "AboutViewController.h"
#import "ListPaymentViewController.h"
#import "HomeViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController {
    NSMutableArray *arrIcon;
    NSMutableArray *arrTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrIcon = [[NSMutableArray alloc]initWithObjects:@"ic_home.png",@"ic_logout.jpeg",@"ic_about.jpeg",@"ic_menu.png", nil];
    arrTitle = [[NSMutableArray alloc]initWithObjects:@"Home",@"Logout",@"About",@"List", nil];
    [_tblView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"MenuTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrTitle.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.image_icon.image = [UIImage imageNamed:[arrIcon objectAtIndex:indexPath.row]];
    cell.lblTitle.text = [arrTitle objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutViewController *about = [[AboutViewController alloc]init];
    UINavigationController *narAbout = [[UINavigationController alloc]initWithRootViewController:about];
    narAbout.navigationBarHidden = YES;
    
    HomeViewController *home = [[HomeViewController alloc]init];
    UINavigationController *narHome = [[UINavigationController alloc]initWithRootViewController:home];
    narHome.navigationBarHidden = YES;
    
    ListPaymentViewController *list = [[ListPaymentViewController alloc]init];
    UINavigationController *narList = [[UINavigationController alloc]initWithRootViewController:list];
    narList.navigationBarHidden = YES;
    
     SWRevealViewController *reveal = self.revealViewController;
    if (indexPath.row==1) {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"NOTIFICATION"
                                                                      message:@"Do you want logout"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"YES"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"check"];
                                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"check"];
                                        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                        [appdelegate checkViewLogin];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"NO"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.row ==2) {
        [reveal pushFrontViewController:narAbout animated:true];
    } else if (indexPath.row ==0){
        [reveal pushFrontViewController:narHome animated:true];
    } else {
        [reveal pushFrontViewController:narList animated:true];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
