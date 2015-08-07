//
//  PopSignUtil.m
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//

#import "PopSignUtil.h"
#import "TYAppDelegate.h"


static PopSignUtil *popSignUtil = nil;

@implementation PopSignUtil{
    UIButton *okBtn;
    UIButton *cancelBtn;
    //遮罩层
    UIView *zhezhaoView;
}


//取得单例实例(线程安全写法)
+(id)shareRestance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popSignUtil = [[PopSignUtil alloc]init];
    });
    return popSignUtil;
}


/** 构造函数 */
-(id)init{
    self = [super init];
    if (self) {
        //遮罩层
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return self;
}

//定制弹出框。模态对话框。
+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
         withCancel:(CallBackBlock)callBackBlock{
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p setPopWithVC:VC withOk:signCallBackBlock withCancel:callBackBlock];
}


/** 设定 */
-(void)setPopWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
         withCancel:(CallBackBlock)cancelBlock{

    if (!zhezhaoView) {
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    TYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.myView addSubview:zhezhaoView];
    CGSize screenSize = [appDelegate.myView bounds].size;
    zhezhaoView.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);

    DrawSignView *conformView = [[DrawSignView alloc]init];
//    [conformView setConformMsg:@"XXX" okTitle:@"确定" cancelTitle:@"取消"];
//    conformView.yesB = yesB;
//    conformView.noB = noB;
    conformView.cancelBlock = cancelBlock;
    [cancelBlock release];
    conformView.signCallBackBlock  = signCallBackBlock;
    [signCallBackBlock release];

    CGFloat v_x = (screenSize.width-conformView.frame.size.width)/2.0;
    CGFloat v_y = (screenSize.height-conformView.frame.size.height)/2.0;
    conformView.frame = CGRectMake( v_x, v_y, conformView.frame.size.width,conformView.frame.size.height);
    [zhezhaoView addSubview:conformView];
    [conformView release];

    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    zhezhaoView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    [UIView commitAnimations];
}


/** 关闭弹出框 */
+(void)closePop{
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p closePop];
}


/** 关闭弹出框 */
-(void)closePop{
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    [CATransaction begin];
    [UIView animateWithDuration:0.25f animations:^{
        zhezhaoView.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);
    } completion:^(BOOL finished) {
        //都关闭啊都关闭
        [zhezhaoView removeFromSuperview];
        [zhezhaoView release];
        zhezhaoView = nil;
    }];
    [CATransaction commit];
}




@end
