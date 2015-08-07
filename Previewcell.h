//
//  Previewcell.h
//  HandScore
//
//  Created by lyn on 14-5-13.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Previewcell : UITableViewCell
@property (copy,nonatomic)NSString *id;
@property (copy,nonatomic)NSArray *content;
@property (copy,nonatomic)NSArray *score;
@property (copy,nonatomic)NSArray *message;
@property (weak, nonatomic) IBOutlet UILabel *methodid;
@property (weak, nonatomic) IBOutlet UILabel *methodcontent;
@property (weak, nonatomic) IBOutlet UILabel *methoodscore;
@property (weak, nonatomic) IBOutlet UILabel *methodmessage;

@end
