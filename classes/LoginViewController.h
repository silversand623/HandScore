//
//  LoginViewController.h
//  HandScore
//
//  Created by lyn on 14-5-12.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;

- (IBAction)setupIP:(id)sender;

- (IBAction)jump:(id)sender;

typedef enum
{
    //以下是枚举成员
    PwdError = -2,
    UserError = -1,
    NoExam = 0,
    Success = 1
}LoginResult;//枚举名称

@end
