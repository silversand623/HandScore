//
//  MyUIView.h
//  UI-Exercise4
//
//  Created by Ibokan on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyUIView : UIView
{
    int rollBackCount;
}
@property(nonatomic,retain)NSMutableArray *line;
@property(nonatomic,retain)NSMutableArray *lines;
@property(nonatomic,retain)UIColor * segmentedColor;
@property(nonatomic,retain)NSMutableArray *tempLine;
@end
