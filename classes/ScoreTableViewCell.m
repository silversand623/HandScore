//
//  ScoreCell.m
//  HandScore
//
//  Created by lyn on 14-8-25.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "ScoreTableViewCell.h"
//#import "AXRatingView.h"

@implementation ScoreTableViewCell
@synthesize ScoreItem,ScoreValue;

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

@end
