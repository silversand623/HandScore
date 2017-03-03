//
//  Settings.m
//  HandScore
//
//  Created by lyn on 14-11-20.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "Settings.h"
#import "TYAppDelegate.h"
#import "Student.h"

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
    NSString *sTime = [defaults objectForKey:@"Time"];
    //[defaults setObject:@"1" forKey:@"Step"];
    //[defaults setObject:@"0" forKey:@"Mode"];
    
    
    NSString *sMode = [defaults objectForKey:@"Mode"];
    NSString *step = [defaults objectForKey:@"Step"];
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
    
     
    self.txtTime.delegate = self;
    
    
    if (sTime != nil) {
        [[self txtTime] setText:sTime];
    } else {
        [[self txtTime] setText:@"1"];
    }
    
    
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
    NSString *sTime = [[self txtTime] text];
    
    
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    Student *Info = (Student*)appDelegate.gStudnetArray[0];
    
    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setLocale: local];
    [formater setDateFormat:@"MM-dd HH:mm:ss"];
    NSDateFormatter* formater1 = [[NSDateFormatter alloc] init];
    [formater1 setLocale: local];
    [formater1 setDateFormat:@"MM-dd HH:mm:ss"];
    NSDate* dateStart = [formater1 dateFromString:Info.Exam_StartTime];
    NSDate* dateEnd = [formater1 dateFromString:Info.Exam_EndTime];
    NSTimeInterval tmInterval1= [dateEnd timeIntervalSinceDate:dateStart];
    int nInterval = tmInterval1/60;
    
    
    int nSelect = [[self scoreMode] selectedSegmentIndex];
    NSString *sMode = [NSString stringWithFormat:@"%d",nSelect];
    
    if ([self isPureInt:sTime] &&([self isPureFloat:step] || [self isPureInt:step])) {
        
        if ([sTime intValue] < 1 || [sTime intValue] >= nInterval) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"输入范围错误" message:@"输入时间超出考试时间范围" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }else if ([step floatValue] == 0.0 || [step floatValue] > 100.0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"输入范围错误" message:@"请输入0.1-100范围内的数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else
        {
            [defaults setObject:sTime forKey:@"Time"];
            [defaults setObject:step forKey:@"Step"];
            [defaults setObject:sMode forKey:@"Mode"];
            [defaults synchronize];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"updateSet" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
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

-(BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}

-(BOOL)validateDecimal:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (_txtStep == textField) {
        
        BOOL bTag = [self validateDecimal:string];
        if (!bTag) {
            return bTag;
        }
        
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
    }
    
    //如果是限制只能输入数字的文本框
    if (_txtTime==textField) {
        
        return [self validateNumber:string];
        
    }

    return YES;
    
    
}

@end
