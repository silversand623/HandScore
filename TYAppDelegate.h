//
//  TYAppDelegate.h
//  HandScore
//
//  Created by lyn on 14-5-9.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginInfoType;
@interface TYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) UIView *myView;//保存签名需要传递的view
@property(nonatomic,strong) NSMutableArray *gStudnetArray;
@property(nonatomic,strong) LoginInfoType *gLoginItem;
@property NSInteger gSegSelectedIndex;
@property(nonatomic,strong) NSString *gStudentId;
@property(nonatomic,strong) NSMutableArray *gStudentScores;
@property(nonatomic,strong) NSString *gImgPath;

@end
