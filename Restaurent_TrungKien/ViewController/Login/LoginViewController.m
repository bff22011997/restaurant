//
//  LoginViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/25/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "InformationViewController.h"
#import "RegisterViewController.h"
#import "AboutViewController.h"
#import "ListPaymentViewController.h"
#import "DatabaseManager.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    NSMutableArray *nameAlbums;
    NSMutableArray *idsAlbums;
    NSMutableArray *idFromCover;
    NSMutableArray *linkImage;
    NSString *coverImage;
    NSString *cover;
    int j;
    NSMutableArray *arrUser;
    int checkShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    nameAlbums = [[NSMutableArray alloc]init];
    idsAlbums = [[NSMutableArray alloc]init];
    idFromCover = [[NSMutableArray alloc]init];
    linkImage = [[NSMutableArray alloc]init];
    _viewUsername.layer.cornerRadius = 8;
    _viewPassword.layer.cornerRadius = 8;
    _btnLogin.layer.cornerRadius = 8;
    _btnLoginFB.layer.cornerRadius = 8;
    _btnRegister.layer.cornerRadius = 8;
    _btnAbout.layer.cornerRadius = 8;
    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKB)];
    [self.view addGestureRecognizer:tab];
    _txtUsername.delegate = self;
    _txtPassword.delegate = self;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    arrUser = [[NSMutableArray alloc]init];
    arrUser = [[DatabaseManager defaultDatabaseManager] getAllUser];
    _txtUsername.text = @"";
    _txtPassword.text = @"";
}
#pragma mark hidden Keyboard
-(void) hiddenKB {
    [self.view endEditing:YES];
}
#pragma mark Check password
- (IBAction)changeLayoutKB:(id)sender {
    
    if ([_txtPassword.text isEqualToString:@""]) {
        _txtPassword.enablesReturnKeyAutomatically = YES;
    }
    else {
        _txtPassword.enablesReturnKeyAutomatically = NO;
        _txtPassword.returnKeyType = UIReturnKeyContinue;
        
    }
    
   
}
#pragma mark delegate TextField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return true;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _txtUsername) {
        [_txtPassword becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
        [self login];
    }
    return YES;
}
#pragma mark Show Password
- (IBAction)onShow:(id)sender {
    _txtPassword.secureTextEntry = !_txtPassword.secureTextEntry;
}
#pragma mark Change Color Return Key
-(NSArray*)subviewsOfView:(UIView*)view withType:(NSString*)type{
    NSString *prefix = [NSString stringWithFormat:@"<%@",type];
    NSMutableArray *subviewArray = [NSMutableArray array];
    for (UIView *subview in view.subviews) {
        NSArray *tempArray = [self subviewsOfView:subview withType:type];
        for (UIView *view in tempArray) {
            [subviewArray addObject:view];
        }
    }
    if ([[view description]hasPrefix:prefix]) {
        [subviewArray addObject:view];
    }
    return [NSArray arrayWithArray:subviewArray];
}

-(void)addColorToUIKeyboardButton{
    for (UIWindow *keyboardWindow in [[UIApplication sharedApplication] windows]) {
        for (UIView *keyboard in [keyboardWindow subviews]) {
            for (UIView *view in [self subviewsOfView:keyboard withType:@"UIKBKeyplaneView"]) {
                UIView *newView = [[UIView alloc] initWithFrame:[(UIView *)[[self subviewsOfView:keyboard withType:@"UIKBKeyView"] lastObject] frame]];
                newView.frame = CGRectMake(newView.frame.origin.x + 2, newView.frame.origin.y + 1, newView.frame.size.width - 4, newView.frame.size.height -3);
                [newView setBackgroundColor:[UIColor blueColor]];
                newView.layer.cornerRadius = 4;
                [view insertSubview:newView belowSubview:((UIView *)[[self subviewsOfView:keyboard withType:@"UIKBKeyView"] lastObject])];
                
            }
        }
    }
}
#pragma mark Login
-(void) login {
    if ([_txtUsername.text isEqualToString:@"admin"] && [_txtPassword.text isEqualToString:@"admin"]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"check"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"check"];
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelegate checkViewHome];
    } else {
        for (int i=0; i<arrUser.count; i++) {
            User *u = [arrUser objectAtIndex:i];
            if ([_txtUsername.text isEqualToString:u.Username] && [_txtPassword.text isEqualToString:u.Password]) {
                j = 1;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"check"];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"check"];
                AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appdelegate checkViewHome];
                break;
                
            }
        }
        if (j == 0) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"ERROR"
                                         message:@"Please input the account"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self.navigationController popViewControllerAnimated:true];
                                           return ;
                                       }];
            
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
- (IBAction)onLogin:(id)sender {
    [self login];
    
}
- (IBAction)onLoginFB:(id)sender {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc]init];
    [loginManager logInWithReadPermissions:@[@"email",@"public_profile",@"user_birthday",@"user_friends",@"user_photos"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if(error) {
            NSLog(@"process error");
        } else if (result.isCancelled) {
            NSLog(@"result cancelled");
        }else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"check"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"check"];
            NSLog(@"Login successful");
            NSLog(@"Success %@",result.token.userID);
            [self fetchUserID];
            [loginManager logOut];
            [FBSDKAccessToken setCurrentAccessToken:nil];
        }
    }];
    
}

-(void) fetchUserID  {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                           parameters:@{@"fields": @"picture, email,name,gender, birthday,cover,albums"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 InformationViewController *infor = [[InformationViewController alloc]init];
                 infor.namePerson = [result valueForKey:@"name"];
                 infor.birthdayPerson = [result valueForKey:@"birthday"];
                 NSDictionary *dic = [result valueForKey:@"cover"];
                 NSArray *arr = [result valueForKey:@"albums"];
                 NSArray *data1 = [arr valueForKey:@"data"];
                 nameAlbums = [data1 valueForKey:@"name"];
                 idsAlbums = [data1 valueForKey:@"id"];
                 coverImage = dic[@"source"];
                 id url = result[@"picture"][@"data"][@"@url"];
                 if (url == nil) {
                     NSLog(@"nil");
                 } else {
                     NSLog(@"do something");
                 }
//                 infor.imageAvatarPerson =
                 [self.navigationController pushViewController:infor animated:true];
             }
         }];
        
    }
}

#pragma mark Register
- (IBAction)onRegiter:(id)sender {
    RegisterViewController *reg = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:reg animated:true];
}
#pragma mark About
- (IBAction)onAbout:(id)sender {
    AboutViewController *about = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:about animated:true];
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
