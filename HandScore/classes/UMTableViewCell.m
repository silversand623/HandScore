//
//  UMTableViewCell.m
//  SWTableViewCell
//
//  Created by Matt Bowman on 12/2/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import "UMTableViewCell.h"


@implementation UMTableViewCell

@synthesize image,labelName,labelTime,labelExamNo,labelStudentNo,labelClassName,labelStatus,labelScore;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

@end
