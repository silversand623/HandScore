//
//  LoginInfoType.h
//  HandScore
//
//  Created by lyn on 14-8-21.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfoType : NSObject

@property (strong,nonatomic) NSString *result;
@property (strong,nonatomic) NSString *U_ID;
@property (strong,nonatomic) NSString *E_ID;
@property (strong,nonatomic) NSString *E_Name;
@property (strong,nonatomic) NSString *U_TrueName;
@property (strong,nonatomic) NSString *ES_ID;
@property (strong,nonatomic) NSString *ES_Name;
@property (strong,nonatomic) NSString *Room_Name;
@property (strong,nonatomic) NSString *mark_sheet_count;
@property (strong,nonatomic) NSString *Room_ID;
@property (strong,nonatomic) NSString *EU_ID;//考试用户id
@property (strong,nonatomic) NSString *ESR_ID;//考站房间id

@end
