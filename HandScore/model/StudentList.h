//
//  StudentList.h
//  HandScore
//
//  Created by lyn on 14-8-21.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentList : NSObject

@property (strong,nonatomic) NSString *result;
@property (strong,nonatomic) NSString *page_index;
@property (strong,nonatomic) NSMutableArray *student_list;

@end
