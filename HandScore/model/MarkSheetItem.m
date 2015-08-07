//
//  MarkSheetItem.m
//  HandScore
//
//  Created by lyn on 14-8-25.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "MarkSheetItem.h"

@implementation MarkSheetItem
@synthesize MSI_ID,MSI_Item,MSI_Score,Item_Score,step_value,rating_value;

#pragma mark - nscoding delegate
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.MSI_ID forKey:@"MSI_ID"];
    [aCoder encodeObject:self.MSI_Item forKey:@"MSI_Item"];
    [aCoder encodeObject:self.MSI_Score forKey:@"MSI_Score"];
    [aCoder encodeObject:self.Item_Score forKey:@"Item_Score"];
    [aCoder encodeObject:self.step_value forKey:@"step_value"];
    [aCoder encodeObject:self.rating_value forKey:@"rating_value"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.MSI_ID = [aDecoder decodeObjectForKey:@"MSI_ID"];
        self.MSI_Item = [aDecoder decodeObjectForKey:@"MSI_Item"];
        self.MSI_Score = [aDecoder decodeObjectForKey:@"MSI_Score"];
        self.Item_Score = [aDecoder decodeObjectForKey:@"Item_Score"];
        self.step_value = [aDecoder decodeObjectForKey:@"step_value"];
        self.rating_value = [aDecoder decodeObjectForKey:@"rating_value"];
    }
    return self;
}

@end
