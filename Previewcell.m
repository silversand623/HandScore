//
//  Previewcell.m
//  HandScore
//
//  Created by lyn on 14-5-13.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "Previewcell.h"

@implementation Previewcell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setId:(NSString *)n
{
    if(![n isEqualToString:_id]){
        _id=[n copy];
        _methodid.text=_id;
    }
}
- (void)setContent:(NSArray *)c
{
    if(![c isEqualToArray:_content]){
        _content=[c copy];
       // _methodcontent.text=_content;
    }
}
- (void)setScore:(NSArray *)d
{
    if(![d isEqualToArray:_score]){
        _score=[d copy];
      
        

       // _methoodscore.text=_score;
    }
}
- (void)setMessage:(NSArray *)e
{
    if(![e isEqualToArray:_message]){
        _message=[e copy];
        UILabel  *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 88, 39*[_content count])];
        lable1.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
        lable1.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
        lable1.text=_id;
        lable1.layer.masksToBounds=YES;
        lable1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
        lable1.layer.borderWidth= 1.0f;
         [lable1 setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lable1];
        for(int i=0;i<[_content count];i++){
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(98,8+39*i,292,35)];
            label2.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            label2.text=[_content[i]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(355,8+39*i,51,35) ];
            label3.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label3.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            label3.text=_score[i];
            [label3 setTextAlignment:NSTextAlignmentCenter];
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(455,8+39*i,51,35) ];
            label4.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label4.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            if([_message count]>i){
                label4.text=_message[i];
            }
            [self addSubview:label2];
            [self addSubview:label3];
             [self addSubview:label4];
        }
    }
}
@end
