//
//  ScoreTableViewController.h
//  HandScore
//
//  Created by lyn on 14-5-12.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labellogout;
@property (weak, nonatomic) IBOutlet UILabel *appuser;
@property (weak, nonatomic) IBOutlet UILabel *examname;
@property (weak, nonatomic) IBOutlet UILabel *showexamname;
@property (weak, nonatomic) IBOutlet UILabel *examclassnum;
@property (weak, nonatomic) IBOutlet UILabel *showexamclassnum;
@property (weak, nonatomic) IBOutlet UILabel *studentexamnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentexamnum;
@property (weak, nonatomic) IBOutlet UILabel *scoretable;
@property (weak, nonatomic) IBOutlet UILabel *showscoretable;
@property (weak, nonatomic) IBOutlet UILabel *labelfont;
@property (weak, nonatomic) IBOutlet UIButton *btnlargefont;
@property (weak, nonatomic) IBOutlet UIButton *btnmiddlefont;
@property (weak, nonatomic) IBOutlet UIButton *btnsmallfont;
@property (weak, nonatomic) IBOutlet UIImageView *showcolor;
@property (weak, nonatomic) IBOutlet UILabel *methodid;
@property (weak, nonatomic) IBOutlet UILabel *methodcontent;
@property (weak, nonatomic) IBOutlet UILabel *methodscore;
@property (weak, nonatomic) IBOutlet UILabel *methodgetscore;
@property (weak, nonatomic) IBOutlet UILabel *methodwritemessage;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSMutableArray *computers;
@property int indexpath;
@property (copy,nonatomic)NSString *id;
@property (copy,nonatomic)NSArray *content;
@property (copy,nonatomic)NSArray *score;
@property (copy,nonatomic)NSString *size;
@property (copy,nonatomic)NSString *size1;
@property (copy,nonatomic)NSMutableDictionary *value;
@property (copy,nonatomic)NSMutableDictionary *flag;
@property (copy,nonatomic)NSMutableDictionary *commet;
@property (copy,nonatomic)NSMutableArray *arrat1;
@property (copy,nonatomic)NSMutableDictionary *arrat2;
@property (copy,nonatomic)NSMutableArray *arrat3;
@property (copy,nonatomic)NSMutableDictionary *arrat4;
@property (copy,nonatomic) NSMutableDictionary *arrat5;
@property (nonatomic, retain) IBOutlet UIPopoverController *poc;
@property BOOL previewreturn;
- (IBAction)back:(id)sender;
- (IBAction)preview:(id)sender;
- (IBAction)largefont:(id)sender;
- (IBAction)middlefont:(id)sender;
- (IBAction)smallfont:(id)sender;




@end
