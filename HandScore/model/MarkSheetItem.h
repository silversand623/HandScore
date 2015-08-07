//
//  MarkSheetItem.h
//  HandScore
//
//  Created by lyn on 14-8-25.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkSheetItem : NSObject<NSCoding>
@property (strong,nonatomic) NSString *MSI_Score;
@property (strong,nonatomic) NSString *MSI_ID;
@property (strong,nonatomic) NSString *MSI_Item;
@property (strong,nonatomic) NSString *rating_value;
@property (strong,nonatomic) NSString *Item_Score;//最终评分
@property (strong,nonatomic) NSString *step_value;

@end
