//
//  AboutViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark Back
- (IBAction)onBack:(id)sender {
    [self.revealViewController revealToggleAnimated:true];
}
#pragma mark Call
- (IBAction)onCall:(id)sender {
        UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString: @"tel:0986485643"] options:@{} completionHandler:nil];
    
}
#pragma mark Contact
- (IBAction)onContact:(id)sender {
    NSString*myurl=@"https://www.facebook.com/soi.convuive";
    NSURL *url = [NSURL URLWithString:myurl];
    [[UIApplication sharedApplication] openURL:url];
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
