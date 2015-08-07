//
//  PreviewViewController.h
//  HandScore
//
//  Created by lyn on 14-5-13.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *appuser;
@property (weak, nonatomic) IBOutlet UILabel *labellogout;
@property (weak, nonatomic) IBOutlet UIImageView *studentimg;
@property (weak, nonatomic) IBOutlet UILabel *studentexamnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentexamnum;
@property (weak, nonatomic) IBOutlet UILabel *studentname;
@property (weak, nonatomic) IBOutlet UILabel *showstudentname;
@property (weak, nonatomic) IBOutlet UILabel *studentnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentnum;
@property (weak, nonatomic) IBOutlet UILabel *studentclassnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentclassnum;
@property (weak, nonatomic) IBOutlet UILabel *studentexamname;
@property (weak, nonatomic) IBOutlet UILabel *showstudentexamname;
@property (weak, nonatomic) IBOutlet UILabel *studentexamclassnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentexamclassnum;
@property (weak, nonatomic) IBOutlet UILabel *studentroomnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentroomnum;
@property (weak, nonatomic) IBOutlet UILabel *writelabel;
@property (weak, nonatomic) IBOutlet UIImageView *showcolor;
@property (weak, nonatomic) IBOutlet UILabel *methoidid;
@property (weak, nonatomic) IBOutlet UILabel *methodcontent;
@property (weak, nonatomic) IBOutlet UILabel *methodgetscore;
@property (weak, nonatomic) IBOutlet UILabel *methodmessage;
@property (weak, nonatomic) IBOutlet UILabel *messageresume;
@property (copy,nonatomic)NSArray *computers;
@property (copy,nonatomic)NSString *id;
@property (copy,nonatomic)NSArray *content;
@property (copy,nonatomic)NSMutableDictionary *score;
@property (copy,nonatomic)NSMutableDictionary *message;

- (IBAction)back:(id)sender;
- (IBAction)submit:(id)sender;

@end
