//
//  DropDown.h
//  UICombox
//
//  Created by Ralbatr on 14-3-17.
//  Copyright (c) 2014年 Ralbatr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreViewController.h"

@interface ComboxView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    
}

@property (nonatomic,retain) UITableView *dropTableView;//下拉列表
@property (nonatomic,retain) NSArray *tableArray;//下拉列表数据
@property (nonatomic,retain) UITextField *textField;//文本输入框
@property(nonatomic, assign) NSObject<PassValueDelegate> * delegate;  //这里用assign而不用retain是为了防止引起循环引用。

- (void)closeTableView;

- (void)closeView;

@end
