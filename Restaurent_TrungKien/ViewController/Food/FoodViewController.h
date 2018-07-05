//
//  FoodViewController.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/25/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+DragLoad.h"

@interface FoodViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITableViewDragLoadDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong,nonatomic) NSString *tableNumber;

@end
