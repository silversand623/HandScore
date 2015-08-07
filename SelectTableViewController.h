//
//  SelectTableViewController.h
//  HandScore
//
//  Created by lyn on 14-5-12.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "AutocompletionTableView.h"
@interface SelectTableViewController : UIViewController<ZBarReaderDelegate,ZBarReaderViewDelegate,AutocompletionTableViewDelegate,UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UIView *view;
//@property (weak, nonatomic) IBOutlet UIButton *scanButton;
//- (IBAction)scanner:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *appuser;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scannerselect;
@property (weak, nonatomic) IBOutlet UILabel *labellogout;
@property (weak, nonatomic) IBOutlet UITextField *texxtfiledexamnum;
@property (weak, nonatomic) IBOutlet UIImageView *studentimg;
@property (weak, nonatomic) IBOutlet UILabel *studentesamnum;
@property (weak, nonatomic) IBOutlet UILabel *studentname;
@property (weak, nonatomic) IBOutlet UILabel *studentnum;
@property (weak, nonatomic) IBOutlet UILabel *studentclassnum;
@property (weak, nonatomic) IBOutlet UILabel *studentexamname;
@property (weak, nonatomic) IBOutlet UILabel *studentexamclassnum;
@property (weak, nonatomic) IBOutlet UILabel *studentrootnum;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *forward;
@property (nonatomic, strong) UIImageView * line;
@property (weak, nonatomic) IBOutlet UILabel *showstudentesamnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentname;
@property (weak, nonatomic) IBOutlet UILabel *showstudentnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentclassnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentexamname;
@property (weak, nonatomic) IBOutlet UILabel *showstudentexamclassnum;
@property (weak, nonatomic) IBOutlet UILabel *showstudentrootnum;
//@property (weak, nonatomic) IBOutlet UILabel *label1;
//@property (weak, nonatomic) IBOutlet UILabel *label2;
//@property (weak, nonatomic) IBOutlet UILabel *label3;
//@property (weak, nonatomic) IBOutlet UILabel *label4;
//@property (weak, nonatomic) IBOutlet UILabel *label5;
//@property (weak, nonatomic) IBOutlet UILabel *label6;
//@property (weak, nonatomic) IBOutlet UILabel *label7;
//@property (weak, nonatomic) IBOutlet UILabel *label8;
//@property (weak, nonatomic) IBOutlet UILabel *label9;
//@property (weak, nonatomic) IBOutlet UILabel *label10;
//@property (weak, nonatomic) IBOutlet UILabel *label12;
//@property (weak, nonatomic) IBOutlet UILabel *label11;
//@property (weak, nonatomic) IBOutlet UILabel *label13;
//@property (weak, nonatomic) IBOutlet UILabel *label14;
//@property (weak, nonatomic) IBOutlet UILabel *label15;
//@property (weak, nonatomic) IBOutlet UILabel *label16;
//@property (weak, nonatomic) IBOutlet UILabel *label17;
//@property (weak, nonatomic) IBOutlet UILabel *label18;
//@property (weak, nonatomic) IBOutlet UILabel *label19;
//@property (weak, nonatomic) IBOutlet UILabel *label20;
//@property (weak, nonatomic) IBOutlet UILabel *label21;
//@property (weak, nonatomic) IBOutlet UILabel *label23;
//@property (weak, nonatomic) IBOutlet UILabel *label22;
//@property (weak, nonatomic) IBOutlet UILabel *label24;
//@property (weak, nonatomic) IBOutlet UILabel *label25;
//@property (weak, nonatomic) IBOutlet UILabel *label26;
//@property (weak, nonatomic) IBOutlet UILabel *label27;
//@property (weak, nonatomic) IBOutlet UILabel *label28;
//@property (weak, nonatomic) IBOutlet UILabel *label29;
//@property (weak, nonatomic) IBOutlet UILabel *label30;
//@property (weak, nonatomic) IBOutlet UILabel *label31;
//@property (weak, nonatomic) IBOutlet UILabel *label32;
//@property (weak, nonatomic) IBOutlet UILabel *label33;
//@property (weak, nonatomic) IBOutlet UILabel *label34;
//@property (weak, nonatomic) IBOutlet UILabel *label35;
//@property (weak, nonatomic) IBOutlet UILabel *label36;
//@property (weak, nonatomic) IBOutlet UILabel *label37;
//@property (weak, nonatomic) IBOutlet UILabel *label38;
//@property (weak, nonatomic) IBOutlet UILabel *label39;
//@property (weak, nonatomic) IBOutlet UILabel *label40;
//@property (weak, nonatomic) IBOutlet UILabel *label42;
//@property (weak, nonatomic) IBOutlet UILabel *label41;
//@property (weak, nonatomic) IBOutlet UILabel *label43;
//@property (weak, nonatomic) IBOutlet UILabel *label44;
//@property (weak, nonatomic) IBOutlet UILabel *label45;
//@property (weak, nonatomic) IBOutlet UILabel *label46;
//@property (weak, nonatomic) IBOutlet UILabel *label47;
//@property (weak, nonatomic) IBOutlet UILabel *label48;
//@property (weak, nonatomic) IBOutlet UILabel *label49;
//@property (weak, nonatomic) IBOutlet UILabel *label50;
//@property (weak, nonatomic) IBOutlet UILabel *label51;
//@property (weak, nonatomic) IBOutlet UILabel *label52;
//@property (weak, nonatomic) IBOutlet UILabel *label53;
//@property (weak, nonatomic) IBOutlet UILabel *label54;
- (IBAction)backlogin:(id)sender;
- (IBAction)forwardscore:(id)sender;
- (void)updateDate;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
