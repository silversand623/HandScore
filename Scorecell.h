//
//  Scorecell.h
//  HandScore
//
//  Created by lyn on 14-5-13.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Scorecell : UITableViewCell<UIPopoverControllerDelegate,UITextFieldDelegate>
@property (copy,nonatomic)NSString *id;
@property (copy,nonatomic)NSArray *content;
@property (copy,nonatomic)NSArray *score;
@property (copy,nonatomic)NSString *size;
@property (copy,nonatomic)NSString *size1;
@property (copy,nonatomic)NSArray *value;
@property (copy,nonatomic)NSArray *flag;
@property (copy,nonatomic)NSArray *commet;
@property (copy,nonatomic)NSMutableArray *computers;
@property (copy,nonatomic)NSMutableArray *arrat1;
@property (copy,nonatomic)NSMutableArray *arrat2;
@property (copy,nonatomic)NSMutableArray *arrat3;
@property (copy,nonatomic)NSMutableArray *arrat4;
@property (copy,nonatomic) NSMutableArray *arrat5;
@property int indexpath;
@property (weak, nonatomic) IBOutlet UILabel *methodid;
@property (weak, nonatomic) IBOutlet UILabel *methodcontent;
@property (weak, nonatomic) IBOutlet UILabel *methodscore;
@property (weak, nonatomic) IBOutlet UIButton *dropdown;
- (IBAction)scoreadd:(id)sender;
- (IBAction)scorereduce:(id)sender;
- (IBAction)methodcorrect:(id)sender;
- (IBAction)methoderror:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *methodmessage;
@property (weak, nonatomic) IBOutlet UITextField *getscore;
@property (weak, nonatomic) IBOutlet UIButton *btndui;
@property (weak, nonatomic) IBOutlet UIButton *btncuo;
@property (nonatomic, retain) IBOutlet UIPopoverController *poc;
- (IBAction)downlist:(id)sender;


@end
