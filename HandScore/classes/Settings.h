//
//  Settings.h
//  HandScore
//
//  Created by lyn on 14-11-20.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtStep;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scoreMode;
- (IBAction)saveSetting:(id)sender;
- (IBAction)exitSetting:(id)sender;

@end
