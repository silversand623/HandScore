//
//  MarkSheetItem.h
//  HandScore
//
//  Created by lyn on 14-8-25.
//  Copyright (c) 2014年 TY. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface DetailItems : NSObject
@property (strong,nonatomic) NSString *MSIRD_ID;
@property (strong,nonatomic) NSString *MSIRD_Item;
@property (strong,nonatomic) NSString *MSIRD_Score;
@end

@interface MarkSheetItem : NSObject
@property (strong,nonatomic) NSString *MSI_Score;
@property (strong,nonatomic) NSString *MSI_ID;
@property (strong,nonatomic) NSString *MSI_Item;
@property (strong,nonatomic) NSString *rating_value;
@property (strong,nonatomic) NSString *Item_Score;//最终评分
@property (strong,nonatomic) NSString *step_value;
@property (strong,nonatomic) NSString *Score_Type;
@property (nonatomic) NSArray *item_detail_list;
@property (strong,nonatomic) NSString *MSIRD_ID;
@end
