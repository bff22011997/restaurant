//
//  MenuViewController.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 7/5/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end
