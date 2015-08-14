//
//  Settings.m
//  HandScore
//
//  Created by lyn on 14-11-20.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *step = [defaults objectForKey:@"Step"];
    NSString *sMode = [defaults objectForKey:@"Mode"];
    if (step != nil) {
        [[self txtStep] setText:step];
    } else {
        [[self txtStep] setText:@"1"];
    }
    if (sMode != nil) {
        int nSelect = [sMode integerValue];
        [[self scoreMode] setSelectedSegmentIndex:nSelect];
    } else {
        [[self scoreMode] setSelectedSegmentIndex:0];
    }
    self.txtStep.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  保存评分步长和评分机制
 *
 *  @param sender 保存按钮
 */
- (IBAction)saveSetting:(id)sender {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *step = [[self txtStep] text];
    int nSelect = [[self scoreMode] selectedSegmentIndex];
    NSString *sMode = [NSString stringWithFormat:@"%d",nSelect];
    if ([self isPureFloat:step] || [self isPureInt:step]) {
        
        [defaults setObject:step forKey:@"Step"];
        [defaults setObject:sMode forKey:@"Mode"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSet" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"格式错误" message:@"请输入正确的数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

/**
 *  退出设置界面
 *
 *  @param sender 设置按钮
 */
- (IBAction)exitSetting:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    
    const NSInteger limited = 1;//小数点后需要限制的个数
    
    for (int i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {

            if (flag > limited) {
                
                return NO;
            }
            
            
            break;
        }
        
        flag++;
        
    }

    return YES;
    
    
}

@end
