//
//  TestViewController.h
//  PopoverController
//
//  Created by lcc on 12-12-3.
//  Copyright (c) 2012年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scorecell.h"

@interface TestViewController : UIViewController< UITableViewDelegate, UITableViewDataSource,UIPopoverControllerDelegate >
@property NSMutableArray *comboBoxDatasource;
@property (nonatomic,assign) Scorecell *scorecell;
@property (nonatomic, retain) IBOutlet UIPopoverController *poc;
@property (weak, nonatomic) IBOutlet UITextField *getscore;
@property (copy,nonatomic)NSMutableDictionary *arrat2;
@property NSMutableArray *Datasource;
@property NSMutableArray *dara1;
@property int bb;
@property int oo;
@end
