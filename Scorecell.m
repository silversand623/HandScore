//
//  Scorecell.m
//  HandScore
//
//  Created by lyn on 14-5-13.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "Scorecell.h"
#import "ComboBoxView.h"
#import "ScoreTableViewController.h"
#import "TYAppDelegate.h"
@implementation Scorecell
UITableView		*comboBoxTableView;
int oo;
int insert;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)scoreadd:(id)sender {
    NSString *empty=@"";
   // NSMutableArray *newarray = [_computers mutableCopy];
      TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    if([_getscore.text compare:empty]== 0){
        NSMutableArray *newarray;
        if(delegate.update==nil){
            newarray = [_computers mutableCopy];
        }else{
            newarray=[delegate.update mutableCopy];
        }

        NSMutableDictionary *rowData=newarray[_indexpath];
        NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
        [rowData1 setObject:rowData[@"Id"] forKey:@"Id"];
        [rowData1 setObject:rowData[@"Content"] forKey:@"Content"];
        [rowData1 setObject:rowData[@"Score"] forKey:@"Score"];
        [rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
        [rowData1 setObject:_score forKey:@"GetScore"];
         [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
        _computers=newarray;
        delegate.update=newarray;
            _getscore.text=_score;
    }else{
        int num=[_getscore.text intValue];
       // if(num==[_score intValue]){
            
      //  }else{
        NSString *stringInt = [NSString stringWithFormat:@"%d",num+1];
            NSMutableArray *newarray;
            if(delegate.update==nil){
                newarray = [_computers mutableCopy];
            }else{
                newarray=[delegate.update mutableCopy];
            }

            NSMutableDictionary *rowData=newarray[_indexpath];
            NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
            [rowData1 setObject:rowData[@"Id"] forKey:@"Id"];
            [rowData1 setObject:rowData[@"Content"] forKey:@"Content"];
            [rowData1 setObject:rowData[@"Score"] forKey:@"Score"];
            [rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
            [rowData1 setObject:stringInt forKey:@"GetScore"];
            [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
            delegate.update=newarray;      _computers=newarray;      _getscore.text=stringInt;
        }
   // }
   
}

- (IBAction)scorereduce:(id)sender {
    NSString *empty=@"";
     //NSMutableArray *newarray = [_computers mutableCopy];
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    if([_getscore.text compare:empty]== 0){
        
    }else{
        int num=[_getscore.text intValue];
        if(num==0){
            NSMutableArray *newarray;
            if(delegate.update==nil){
                newarray = [_computers mutableCopy];
            }else{
                newarray=[delegate.update mutableCopy];
            }

            NSMutableDictionary *rowData=newarray[_indexpath];
            NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
            [rowData1 setObject:rowData[@"Id"] forKey:@"Id"];
            [rowData1 setObject:rowData[@"Content"] forKey:@"Content"];
            [rowData1 setObject:rowData[@"Score"] forKey:@"Score"];
            [rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
            [rowData1 setObject:@"0" forKey:@"GetScore"];
            [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
            delegate.update=newarray;
             _computers=newarray;

        }else{
        NSString *stringInt = [NSString stringWithFormat:@"%d",num-1];
            NSMutableArray *newarray;
            if(delegate.update==nil){
                newarray = [_computers mutableCopy];
            }else{
                newarray=[delegate.update mutableCopy];
            }

            NSMutableDictionary *rowData=newarray[_indexpath];
            NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
            [rowData1 setObject:rowData[@"Id"] forKey:@"Id"];
            [rowData1 setObject:rowData[@"Content"] forKey:@"Content"];
            [rowData1 setObject:rowData[@"Score"] forKey:@"Score"];
            [rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
            [rowData1 setObject:stringInt forKey:@"GetScore"];
            [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
           delegate.update=newarray;
             _computers=newarray;
            _getscore.text=stringInt;
        }
    }
    
}

- (IBAction)methodcorrect:(id)sender {
    _getscore.text=_score;
    [_btndui setImage:[UIImage imageNamed:@"btnduis.png"] forState:UIControlStateNormal];
    [_btncuo setImage:[UIImage imageNamed:@"btncuo.png"] forState:UIControlStateNormal];
     TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray *newarray;
    if(delegate.update==nil){
         newarray = [_computers mutableCopy];
    }else{
        newarray=[delegate.update mutableCopy];
    }
    NSMutableDictionary *rowData=newarray[_indexpath];
    NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
    [rowData1 setObject:rowData[@"Id"] forKey:@"Id"];
    [rowData1 setObject:rowData[@"Content"] forKey:@"Content"];
    [rowData1 setObject:rowData[@"Score"] forKey:@"Score"];
    [rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
    [rowData1 setObject:_score forKey:@"GetScore"];
    [rowData1 setObject:@"YES" forKey:@"Flag"];
    [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
    _computers=newarray;
    delegate.update=newarray;
}

- (IBAction)methoderror:(id)sender {
    _getscore.text=@"0";
     [_btncuo setImage:[UIImage imageNamed:@"btncuos.png"] forState:UIControlStateNormal];
    [_btndui setImage:[UIImage imageNamed:@"btndui.png"] forState:UIControlStateNormal];
     TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray *newarray;
    if(delegate.update==nil){
        newarray = [_computers mutableCopy];
    }else{
        newarray=[delegate.update mutableCopy];
    }

   // NSMutableArray *newarray = [_computers mutableCopy];
    NSMutableDictionary *rowData=newarray[_indexpath];
    NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
    [rowData1 setObject:rowData[@"Id"] forKey:@"Id"];
    [rowData1 setObject:rowData[@"Content"] forKey:@"Content"];
    [rowData1 setObject:rowData[@"Score"] forKey:@"Score"];
    [rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
    [rowData1 setObject:@"0" forKey:@"GetScore"];
    [rowData1 setObject:@"NO" forKey:@"Flag"];
    [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
    _computers=newarray;
    delegate.update=newarray;
}
- (void)setId:(NSString *)n
{
    if(![n isEqualToString:_id]){
        _id=[n copy];
//      UILabel  *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 19, 128, 24*[_content count])];
//        lable1.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
//        lable1.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
//        lable1.text=_id;
//        lable1.layer.masksToBounds=YES;
//        lable1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//        lable1.layer.borderWidth= 1.0f;
//        lable1.textAlignment = UITextAlignmentCenter;
//        [self addSubview:lable1];
           }
}
- (void)setContent:(NSArray *)c
{
    if(![c isEqualToArray:_content]){
        _content=[c copy];
        //_methodcontent.text=_content;
    }
}
- (void)setScore:(NSArray *)d
{
    if(![d isEqualToArray:_score]){
        _score=[d copy];
               // _methodscore.text=_score;
    }
}
-(IBAction) buttonClicked:(id)sender {
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.flag=YES;
    UIButton *button = (UIButton *)sender;
    NSString *aa=[NSString stringWithFormat:@"%d",button.tag];
    NSString *bb=[aa substringWithRange:NSMakeRange(0, 2)];
    NSString *cc=[aa substringWithRange:NSMakeRange(2, 1)];
    if([bb compare:@"10"]==0){
        NSMutableArray *arrat=[[NSMutableArray alloc]init];
         UITextField *textfield=(UITextField *)[self viewWithTag:[cc intValue]];
        oo=[cc intValue]-1;
           for (int i=0; i<=[_score[oo] intValue]; i++) {
       [arrat addObject:[NSString stringWithFormat:@"%d",i]];
       }
        
        [self.poc setPopoverContentSize:CGSizeMake(138, 23*([arrat count]+1))];
        CGRect rect =CGRectMake(374, 43+39*oo, 138, 23*([arrat count]+1));
        //设置箭头坐标--也是设置如何显示这个浮动框
        [self.poc presentPopoverFromRect:rect
                                  inView:self
                permittedArrowDirections:UIPopoverArrowDirectionLeft//可以任意换--换换看，你立马就知道
                                animated:NO];
    }else if([bb compare:@"20"]==0){
        NSString *empty=@"";
        // NSMutableArray *newarray = [_computers mutableCopy];
        if(_arrat2==nil){
            _arrat2=[NSMutableArray arrayWithCapacity:100];
        }
        UITextField *textfield=(UITextField *)[self viewWithTag:[cc intValue]];
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
        if([textfield.text compare:empty]== 0){
            NSMutableArray *newarray;
            if(delegate.update==nil){
                newarray = [_computers mutableCopy];
            }else{
                newarray=[delegate.update mutableCopy];
            }
            
            NSMutableDictionary *rowData=newarray[_indexpath];
            NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
            [rowData1 setObject:rowData[@"MSI_Item"]  forKey:@"MSI_Item"];
            [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
            [rowData1 setObject:rowData[@"MSI_ItemName"] forKey:@"MSI_ItemName"];
            if([_arrat2 count]==0){
                [_arrat2 insertObject:_score[[cc intValue]-1] atIndex:([cc intValue]-1)];
                
            }else if([_arrat2 count]<=[cc intValue]){
                [_arrat2 insertObject:_score[[cc intValue]-1] atIndex:([cc intValue]-1)];
            }else if(_arrat2[([cc intValue]-1)]!=nil){
                [_arrat2 replaceObjectAtIndex:([cc intValue]-1) withObject:_score[[cc intValue]-1]];
            }

            //[_arrat2 insertObject:_score[oo] atIndex:oo];
            //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
            [rowData1 setObject:_arrat2 forKey:@"GetScore"];
            [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
            _computers=newarray;
            delegate.update=newarray;
            UITextField *textfield=(id)[self viewWithTag:[cc intValue]];
            textfield.text=_score[([cc intValue]-1)];

        }else{
            UITextField *textfield=(UITextField *)[self viewWithTag:[cc intValue]];
            int num=[textfield.text intValue];
            // if(num==[_score intValue]){
            
            //  }else{
            NSString *stringInt = [NSString stringWithFormat:@"%d",num+1];
            NSMutableArray *newarray;
            if(delegate.update==nil){
                newarray = [_computers mutableCopy];
            }else{
                newarray=[delegate.update mutableCopy];
            }
            
            NSMutableDictionary *rowData=newarray[_indexpath];
            NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
            [rowData1 setObject:rowData[@"MSI_Item"]forKey:@"MSI_Item"];
            [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
            [rowData1 setObject:rowData[@"MSI_ItemName"]  forKey:@"MSI_ItemName"];
            //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
            if([_arrat2 count]==0){
                [_arrat2 insertObject:stringInt atIndex:([cc intValue]-1)];
                
            }else if([_arrat2 count]<=[cc intValue]){
                [_arrat2 insertObject:stringInt atIndex:([cc intValue]-1)];
            }else {
                [_arrat2 replaceObjectAtIndex:([cc intValue]-1) withObject:stringInt];
            }
            
            [rowData1 setObject:_arrat2 forKey:@"GetScore"];
            [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
            delegate.update=newarray;      _computers=newarray;     textfield.text=stringInt;
           
        }

    }else if([bb compare:@"30"]==0){
        NSString *empty=@"";
        if(_arrat2==nil){
            _arrat2=[NSMutableArray arrayWithCapacity:100];
        }
        //NSMutableArray *newarray = [_computers mutableCopy];
         UITextField *textfield=(UITextField *)[self viewWithTag:[cc intValue]];
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
            if([textfield.text compare:empty]== 0){
            
        }else{
            UITextField *textfield=(UITextField *)[self viewWithTag:[cc intValue]];
                    int num=[textfield.text intValue];
            if(num==0){
                NSMutableArray *newarray;
                if(delegate.update==nil){
                    newarray = [_computers mutableCopy];
                }else{
                    newarray=[delegate.update mutableCopy];
                }
                
                NSMutableDictionary *rowData=newarray[_indexpath];
                NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
                [rowData1 setObject:rowData[@"MSI_Item"] forKey:@"MSI_Item"];
                [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
                [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
                //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
                if([_arrat2 count]==0){
                    [_arrat2 insertObject:@"0" atIndex:([cc intValue]-1)];
                    
                }else if([_arrat2 count]<=[cc intValue]){
                    [_arrat2 insertObject:@"0'" atIndex:([cc intValue]-1)];
                }else{
                    [_arrat2 replaceObjectAtIndex:([cc intValue]-1) withObject:@"0"];
                }
                [rowData1 setObject:_arrat2 forKey:@"GetScore"];
                [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
                delegate.update=newarray;
                _computers=newarray;
                
            }else{
                NSString *stringInt = [NSString stringWithFormat:@"%d",num-1];
                NSMutableArray *newarray;
                if(delegate.update==nil){
                    newarray = [_computers mutableCopy];
                }else{
                    newarray=[delegate.update mutableCopy];
                }
                
                NSMutableDictionary *rowData=newarray[_indexpath];
                NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
                [rowData1 setObject:rowData[@"MSI_Item"]forKey:@"MSI_Item"];
                [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
                [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
                //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
                if([_arrat2 count]==0){
                    [_arrat2 insertObject:stringInt atIndex:([cc intValue]-1)];
                    
                }else if([_arrat2 count]<=[cc intValue]){
                    [_arrat2 insertObject:stringInt atIndex:([cc intValue]-1)];
                }else {
                    [_arrat2 replaceObjectAtIndex:([cc intValue]-1) withObject:stringInt];
                }

               
                [rowData1 setObject:_arrat2 forKey:@"GetScore"];
                [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
                delegate.update=newarray;
                _computers=newarray;
                UITextField *textfield=(id)[self viewWithTag:[cc intValue]];
                [textfield removeFromSuperview];
                textfield.text=stringInt;
                          }
        }
    }else if([bb compare:@"40"]==0){
        if(_arrat2==nil){
            _arrat2=[NSMutableArray arrayWithCapacity:100];
        }
        if(_arrat4==nil){
            _arrat4=[NSMutableArray arrayWithCapacity:100];

        }
        UITextField *textfield=(id)[self viewWithTag:[cc intValue]];
         UIButton *button1=(id)[self viewWithTag:(500+[cc intValue])];
            textfield.text=_score[oo];
        [button setImage:[UIImage imageNamed:@"btnduis.png"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"btncuo.png"] forState:UIControlStateNormal];
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
        NSMutableArray *newarray;
        if(delegate.update==nil){
            newarray = [_computers mutableCopy];
        }else{
            newarray=[delegate.update mutableCopy];
        }
        NSMutableDictionary *rowData=newarray[_indexpath];
        NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
        [rowData1 setObject:rowData[@"MSI_Item"]  forKey:@"MSI_Item"];
        [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
        [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
         [_arrat2 insertObject:_score[oo] atIndex:oo];
        [_arrat4 insertObject:@"YES" atIndex:oo];
        //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
        [rowData1 setObject:_arrat2 forKey:@"GetScore"];
        [rowData1 setObject:_arrat4 forKey:@"Flag"];
       // NSLog(@"%@",_arrat4);
        [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
        _computers=newarray;
        delegate.update=newarray;
    }else if([bb compare:@"50"]==0){
        UITextField *textfield=(id)[self viewWithTag:[cc intValue]];
        if(_arrat2==nil){
            _arrat2=[NSMutableArray arrayWithCapacity:100];
        }
        if(_arrat4==nil){
            _arrat4=[NSMutableArray arrayWithCapacity:100];
            
        }

        textfield.text=@"0";
         UIButton *button1=(id)[self viewWithTag:(400+[cc intValue])];
        [button setImage:[UIImage imageNamed:@"btncuos.png"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"btndui.png"] forState:UIControlStateNormal];
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
        NSMutableArray *newarray;
        if(delegate.update==nil){
            newarray = [_computers mutableCopy];
        }else{
            newarray=[delegate.update mutableCopy];
        }
        
        // NSMutableArray *newarray = [_computers mutableCopy];
        NSMutableDictionary *rowData=newarray[_indexpath];
        NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
        [rowData1 setObject:rowData[@"MSI_Item"]  forKey:@"MSI_Item"];
        [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
        [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
        //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
        [_arrat2 insertObject:@"0" atIndex:oo];
        [rowData1 setObject:_arrat2 forKey:@"GetScore"];
         [_arrat4 insertObject:@"NO" atIndex:oo];
        [rowData1 setObject:_arrat4 forKey:@"Flag"];
        // NSLog(@"%@",_arrat4);
        [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
        _computers=newarray;
        delegate.update=newarray;

    }
}
- (void)setSize:(NSString *)f
{
    if(![f isEqualToString:_size]){
         _size=[f copy];
        CGFloat aa=[_size floatValue];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [self setUpForDismissKeyboard];
        _methodmessage.delegate=self;
        _methodid.font=[UIFont systemFontOfSize:aa];
        _methodcontent.font=[UIFont systemFontOfSize:aa];
        _methodscore.font=[UIFont systemFontOfSize:aa];
        _getscore.font=[UIFont systemFontOfSize:aa];
        
    }
}
- (void)setValue:(NSArray *)f
{
    if(![f isEqualToArray:_value]){
        _value=[f copy];
        for(int i=0;i<[_value count];i++){
            UITextField *textfield=(UITextField *)[self viewWithTag:i+1];
                    textfield.text=_value[i];

        }
          }
}
- (void)setCommet:(NSArray *)f
{
    if(![f isEqualToArray:_commet]){
        _commet=[f copy];
//        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
//        if(!delegate.flag){
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
          //  [self setUpForDismissKeyboard];

    
        UILabel  *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 128, 39*[_content count])];
        lable1.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
        lable1.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
        lable1.text=_id;
        lable1.layer.masksToBounds=YES;
        lable1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
        lable1.layer.borderWidth= 1.0f;
         [lable1 setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lable1];
        for(int i=0;i<[_content count];i++){
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(138,8+39*i,292,35)];
            label2.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            label2.text=[_content[i]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(425,8+39*i,51,35) ];
            label3.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label3.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            label3.text=_score[i];
            [label3 setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:label2];
            [self addSubview:label3];
            UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(526, 5+39*i, 97, 37)];
            textfield.borderStyle=UITextBorderStyleRoundedRect;
            textfield.layer.borderWidth=1.0;
            textfield.layer.borderColor=[[UIColor blackColor]CGColor];
            textfield.tag=i+1;
            if([_value count]>i){
                  textfield.text=_value[i];
            }
             [textfield setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:textfield];
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(623, 5+39*i, 41, 37)];
            [button setBackgroundImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
            button.tag=100+i+1;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(679, 7+39*i, 48, 34)];
            [button1 setBackgroundImage:[UIImage imageNamed:@"scoreadd"] forState:UIControlStateNormal];
            button1.tag=200+i+1;
            [button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button1];
            UIButton *button2=[[UIButton alloc]initWithFrame:CGRectMake(734, 7+39*i, 48, 34)];
            [button2 setBackgroundImage:[UIImage imageNamed:@"scorereduce"] forState:UIControlStateNormal];
            button2.tag=300+i+1;
            [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button2];
            UIButton *button3=[[UIButton alloc]initWithFrame:CGRectMake(805, 10+39*i, 32, 32)];
           // [button3 setBackgroundImage:[UIImage imageNamed:@"btndui"] forState:UIControlStateNormal];
            button3.tag=400+i+1;
            [button3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIButton *button4=[[UIButton alloc]initWithFrame:CGRectMake(845, 10+39*i, 32, 32)];
           // [button4 setBackgroundImage:[UIImage imageNamed:@"btncuo"] forState:UIControlStateNormal];
            button4.tag=500+i+1;
            [button4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSLog(@"%@",_flag[i]);
            if(_flag[i]==nil){
                [button3 setBackgroundImage:[UIImage imageNamed:@"btndui"] forState:UIControlStateNormal];
                [button4 setBackgroundImage:[UIImage imageNamed:@"btncuo"] forState:UIControlStateNormal];
            }
          else if([_flag[i] compare:@"YES"]==0){
                [button3 setBackgroundImage:[UIImage imageNamed:@"btnduis"] forState:UIControlStateNormal];
                [button4 setBackgroundImage:[UIImage imageNamed:@"btncuo"] forState:UIControlStateNormal];
            }else if([_flag[i] compare:@"NO"]==0){
                [button3 setBackgroundImage:[UIImage imageNamed:@"btndui"] forState:UIControlStateNormal];
                [button4 setBackgroundImage:[UIImage imageNamed:@"btncuos"] forState:UIControlStateNormal];

            }
            
            [self addSubview:button3];
           
            [self addSubview:button4];
            UITextField *textfield1=[[UITextField alloc]initWithFrame:CGRectMake(899, 10+39*i, 99, 30)];
            textfield1.placeholder=@"评论";
            textfield1.borderStyle=UITextBorderStyleRoundedRect;
            textfield1.tag=600+i+1;
            textfield1.delegate=self;
            // textfield1.tag=i;
            [self addSubview:textfield1];
            insert++;
       // }
        }
    }
}
- (void)setFlag:(NSArray *)f
{
   // NSLog(@"%@",f);
    if(![f isEqualToArray:_flag]){
        _flag=[f copy];
        //NSLog(@"%@",_flag);
        for(int i=0;i<[_flag count];i++){
            NSString *uu=_flag[i];
        //    NSLog(@"%@",@"11111");
            if([uu compare:@"YES"]==0){
               //  NSLog(@"%@",@"111111");
                int c=400+i+1;
                NSLog(@"%d",c);
                UIButton *button=(id)[self viewWithTag:c];
                        //NSLog(@"%@",button);
               
                [button setBackgroundImage:[UIImage imageNamed:@"btnduis"] forState:UIControlStateNormal];
                          }else if([uu compare:@"NO"]==0){
               // NSLog(@"%@",@"1111111");
                int c=500+i+1;
                NSLog(@"%d",c);
                  UIButton *button=(id)[self viewWithTag:c];
                                 //NSLog(@"%@",button);
                                [button setBackgroundImage:[UIImage imageNamed:@"btncuos"] forState:UIControlStateNormal];            }
        }
//        if(_flag==nil){
//            
//        }
//        else if([_flag compare:@"YES"]==0){
//         [_btndui setImage:[UIImage imageNamed:@"btnduis.png"] forState:UIControlStateNormal];
//        }else if([_flag compare:@"NO"]==0){
//            [_btncuo setImage:[UIImage imageNamed:@"btncuos.png"] forState:UIControlStateNormal];
//
//        }
            }
}
- (void)popoverdismiss
{
        if(_poc){
        [_poc dismissPopoverAnimated:NO];
      
            //_getscore.text=delegate.stringvalue;
    }
  

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString *aa=[NSString stringWithFormat:@"%d",textField.tag];
   // NSString *bb=[aa substringWithRange:NSMakeRange(0, 2)];
    NSString *cc=[aa substringWithRange:NSMakeRange(2, 1)];
    oo=[cc intValue];
   // NSString *text=textField.text;
    //CGFloat keyboardHeight = 216.0f;
   
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    textField.layer.cornerRadius=8.0f;
//    textField.layer.masksToBounds=YES;
//    textField.layer.borderColor=[[UIColor blueColor]CGColor];
//    textField.layer.borderWidth= 1.0f;
//    return YES;
//}
//该方法为点击虚拟键盘Return，要调用的代理方法：隐藏虚拟键盘

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

//该方法为完成输入后要调用的代理方法：虚拟键盘隐藏后，要恢复到之前的文本框地方
-(void)textFieldDidEndEditing:(UITextField *)textField{
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray *newarray;
   if(delegate.update==nil){
        newarray = [_computers mutableCopy];
   }else{
        newarray=[delegate.update mutableCopy];
    }
    if(_arrat5==nil){
        _arrat5=[NSMutableArray arrayWithCapacity:100];
    }
    NSString *aa=[NSString stringWithFormat:@"%d",textField.tag];
  // NSString *bb=[aa substringWithRange:NSMakeRange(0, 2)];
    NSString *cc=[aa substringWithRange:NSMakeRange(2, 1)];
    oo=[cc intValue];
  //  NSString *text=textField.text;
    // NSMutableArray *newarray = [_computers mutableCopy];
    NSMutableDictionary *rowData=newarray[_indexpath];
    NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
    [rowData1 setObject:rowData[@"MSI_Item"]  forKey:@"MSI_Item"];
    [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
    [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
    if(rowData[@"GetScore"]!=nil){
       [rowData1 setObject:rowData[@"GetScore"] forKey:@"GetScore"];
    }
    if(rowData[@"Flag"]!=nil){
    [rowData1 setObject:rowData[@"Flag"] forKey:@"Flag"];
   }
    [_arrat5 insertObject:textField.text atIndex:([cc intValue]-1)];
    _size1=textField.text;
    [rowData1 setObject:_arrat5 forKey:@"Commet"];
    [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
     _computers=newarray;
    delegate.update=newarray;
    //textField.text=_methodmessage.text;
       [textField resignFirstResponder];
    
}

//- (IBAction)dropdown:(id)sender {
//    comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 26, 138, 140)];
//	comboBoxTableView.dataSource =self;
//	comboBoxTableView.delegate =self;
//    comboBoxTableView.hidden=YES;
//    [self addSubview:comboBoxTableView];
//    
//}
#pragma mark -
#pragma mark - popover delegate
- (IBAction)downlist:(id)sender {
    
//    comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(516, 48, 138, 340)];
//	comboBoxTableView.dataSource =self;
//	comboBoxTableView.delegate =self;
    NSMutableArray *arrat=[[NSMutableArray alloc]init];
//    for (int i=0; i<=[_score intValue]; i++) {
//        [arrat addObject:[NSString stringWithFormat:@"%d",i]];
//  
       [self.poc setPopoverContentSize:CGSizeMake(138, 23*([arrat count]+1))];
    CGRect rect =CGRectMake(364, 49, 138, 23*([arrat count]+1));
    //设置箭头坐标--也是设置如何显示这个浮动框
    [self.poc presentPopoverFromRect:rect
                             inView:self
           permittedArrowDirections:UIPopoverArrowDirectionLeft//可以任意换--换换看，你立马就知道
                           animated:NO];
//    [self addSubview:comboBoxTableView];
}
#pragma mark -
#pragma mark - popover delegate
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
//    NSLog(@"%@",@"谢谢");
//    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
//   // _getscore.text=delegate.stringvalue;
//
//    _getscore.text=delegate.stringvalue;
}
- (void)keyboardHide:(NSNotification *)notif {
//    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
//    NSMutableArray *newarray;
//    if(delegate.update==nil){
//        newarray = [_computers mutableCopy];
//    }else{
//        newarray=[delegate.update mutableCopy];
//    }
//    if(_arrat5==nil){
//        _arrat5=[NSMutableArray arrayWithCapacity:100];
//    }
//    // NSMutableArray *newarray = [_computers mutableCopy];
//    NSMutableDictionary *rowData=newarray[_indexpath];
//    NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
//    [rowData1 setObject:rowData[@"MSI_Item"]  forKey:@"MSI_Item"];
//    [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
//    [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
//    if(rowData[@"GetScore"]!=nil){
//        [rowData1 setObject:rowData[@"GetScore"] forKey:@"GetScore"];
//    }
//    if(rowData[@"Flag"]!=nil){
//        [rowData1 setObject:rowData[@"Flag"] forKey:@"Flag"];
//    }
//  UITextField *textfield=(id)[self viewWithTag:(600+oo+1)];
//    NSLog(@"%@",textfield.text);
//    NSString *aa=textfield.text;
//    [_arrat5 insertObject:textfield.text atIndex:oo-1];
//    [rowData1 setObject:_arrat5 forKey:@"Commet"];
//    [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
//     _computers=newarray;
//    delegate.update=newarray;
    
}
- (void)setUpForDismissKeyboard {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.methodmessage resignFirstResponder];
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray *newarray;
    if(delegate.update==nil){
        newarray = [_computers mutableCopy];
    }else{
        newarray=[delegate.update mutableCopy];
    }
    
    // NSMutableArray *newarray = [_computers mutableCopy];
    NSMutableDictionary *rowData=newarray[_indexpath];
    NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
    [rowData1 setObject:rowData[@"Id"] forKey:@"Id"];
    [rowData1 setObject:rowData[@"Content"] forKey:@"Content"];
    [rowData1 setObject:rowData[@"Score"] forKey:@"Score"];
    [rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
    [rowData1 setObject:rowData[@"GetScore"] forKey:@"GetScore"];
    [rowData1 setObject:rowData[@"Flag"] forKey:@"Flag"];
    [rowData1 setObject:_methodmessage.text forKey:@"Commet"];
    [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
     _computers=newarray;
    delegate.update=newarray;

    
}

@end
