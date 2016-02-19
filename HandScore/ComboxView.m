//
//  DropDown.m
//  UICombox
//
//  Created by Ralbatr on 14-3-17.
//  Copyright (c) 2014年 Ralbatr. All rights reserved.
//

#import "ComboxView.h"

@implementation ComboxView

-(id)initWithFrame:(CGRect)frame
{
    if (frame.size.height<100) {
        frameHeight = 100;
    }else{
        frameHeight = frame.size.height;
    }
    tabheight = frameHeight-30;
    
    frame.size.height = 30.0f;
    
    self = [super initWithFrame:frame];
    
    if(self){
        showList = NO; //默认不显示下拉框
        
        [self creatTableView:frame];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        _textField.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框风格
        _textField.inputView=[[UIView alloc]initWithFrame:CGRectZero];
        _textField.delegate = self;
        [self addSubview:_textField];
        
    }
    return self;
}

- (void)creatTableView:(CGRect)frame
{
    _dropTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 0)];
    _dropTableView.delegate = self;
    _dropTableView.dataSource = self;
    _dropTableView.hidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self dropdown];
    return NO;
}

- (void)closeTableView
{
    if (showList) {
        /*
        //self.hidden = YES;
        [self.dropTableView setHidden:YES];
        [_dropTableView removeFromSuperview];
        showList = NO;
         */
        showList = NO;
        _dropTableView.hidden = YES;
        
        CGRect sf = self.frame;
        sf.size.height = 30;
        self.frame = sf;
        CGRect frame = _dropTableView.frame;
        frame.size.height = 0;
        _dropTableView.frame = frame;
        //选择完后，移除
        [_dropTableView removeFromSuperview];
    }
}

-(void)dropdown{

    if (showList)
    {//如果下拉框已显示，什么都不做
        return;
    }
    else
    {//如果下拉框尚未显示，则进行显示
        
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        [self addSubview:_dropTableView];        
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        _dropTableView.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = _dropTableView.frame;
        frame.size.height = 0;
        _dropTableView.frame = frame;
        frame.size.height = tabheight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        _dropTableView.frame = frame;
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _textField.text = [_tableArray objectAtIndex:[indexPath row]];
    showList = NO;
    _dropTableView.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = _dropTableView.frame;
    frame.size.height = 0;
    _dropTableView.frame = frame;
    //选择完后，移除
    [_dropTableView removeFromSuperview];
    
    [[self delegate] passValue:indexPath.row];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
