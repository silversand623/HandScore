//
//  MyUIView.m
//  UI-Exercise4
//
//  Created by Ibokan on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyUIView.h"
#import "PreviewViewController.h"
#import "TYAppDelegate.h"
@interface MyUIView ()
-(void)back;
-(void)remberColor:(UISegmentedControl *)segmentedControl;
-(void)clearAll;
-(void)rollBack;
@end
UILabel *label;
UIButton *button;
UIButton *button1;
@implementation MyUIView
@synthesize line;
@synthesize lines;
@synthesize segmentedColor;
@synthesize tempLine;

bool bImageTag = FALSE;

UILabel *labelmessage;
- (void)dealloc {
    line=nil;
    lines=nil;
    segmentedColor=nil;
    tempLine=nil;
//    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        rollBackCount=0;
        self.lines=[NSMutableArray arrayWithCapacity:100];
        self.tempLine=[NSMutableArray arrayWithCapacity:100];
         label=[[UILabel alloc]init];
        label.frame=CGRectMake(90, 230, 255, 94);
        label.textColor=[UIColor blackColor];
        label.font=[UIFont fontWithName:@"Helvetica-Bold" size:55];
        label.text=@"手写签名";
        [self addSubview:label];

       button=[[UIButton alloc]init];
        button.frame=CGRectMake(90, 540, 89, 40 );
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"scorebtntemple.png"] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.adjustsImageWhenHighlighted = NO;
        [self addSubview:button];
        
        button1=[[UIButton alloc]init];
        button1.frame=CGRectMake(240, 540, 89, 40);
        [button1 setTitle:@"清空" forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"scorebtntemple.png"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"scorebtntemple.png"] forState:UIControlStateSelected];
        button1.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
        button1.adjustsImageWhenHighlighted = NO;
        [self addSubview:button1];
        
        labelmessage=[[UILabel alloc]init];
        labelmessage.frame=CGRectMake(10, 560, 89, 40);
        labelmessage.textColor=[UIColor redColor];
        labelmessage.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        labelmessage.text=@"";
        [self addSubview:labelmessage];
//        
//        UIButton *button2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        button2.frame=CGRectMake(150, 400, 50, 30  );
//        [button2 setTitle:@"恢复" forState:UIControlStateNormal];
//        [button2 addTarget:self action:@selector(rollBack) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button2];
        
//        UISegmentedControl *segmentedControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"red",@"yellow",@"blue", nil]];
//        segmentedControl.frame=CGRectMake(0, 430, 320, 30);
//        [segmentedControl addTarget:self action:@selector(remberColor:) forControlEvents:UIControlEventValueChanged];
//        [self addSubview:segmentedControl];
        self.segmentedColor=[UIColor blackColor];
    }
    return self;
}
//-(void)rollBack
//{
//    NSArray *tempa=[self.tempLine objectAtIndex:rollBackCount-1];
//    [self.lines addObject:tempa];
//    [self.tempLine removeLastObject];
//    rollBackCount--;
//    [self setNeedsDisplay];
//}
-(void)clearAll
{
       [self.lines removeAllObjects];
    labelmessage.text=@"";
    label.hidden=NO;
    [self setNeedsDisplay];

   
}
//-(void)remberColor:(UISegmentedControl *)segmentedControl
//{
//    if (segmentedControl.selectedSegmentIndex) 
//    {
//        switch (segmentedControl.selectedSegmentIndex) {
//            case 0:
//                self.segmentedColor=[UIColor redColor];
//                break;
//            case 1:
//                self.segmentedColor=[UIColor yellowColor];
//                break;
//            case 2:
//                self.segmentedColor=[UIColor blueColor];
//                break;
//            default:
//                break;
//        }
//    }
//}
-(void)back
{
    if (!bImageTag) {
        //labelmessage=[[UILabel alloc]init];
        labelmessage.frame=CGRectMake(10, 560, 89, 40);
        labelmessage.textColor=[UIColor redColor];
        labelmessage.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        labelmessage.text=@"请签名！";
        [self addSubview:labelmessage];
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.flag=NO;
        
    }
    else {
//    
//    NSArray *tempa=[self.lines objectAtIndex:[self.lines count]-1];
//    [self.tempLine addObject:tempa];
//    rollBackCount++;
//    
//    [self.lines removeLastObject];
//    [self setNeedsDisplay];
        bImageTag = FALSE;
  CGSize size = CGSizeMake(420.0f, 526.0f);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//    imageView.frame=CGRectMake(90, 130, 200, 200);
//    [self addSubview:imageView];
    //labelmessage=[[UILabel alloc]init];
    labelmessage.frame=CGRectMake(10, 560, 89, 40);
    labelmessage.textColor=[UIColor redColor];
    labelmessage.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    labelmessage.text=@"签名成功";
    [self addSubview:labelmessage];
TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.flag=YES;
    // NSString *aPath=[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
//    NSData *imgData = UIImagePNGRepresentation(image);
//    [imgData writeToFile:aPath atomically:YES];
   // [self saveImageToCacheDir:image];
    [self test:image];
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300,300), NO, 0);
//    
//    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,300,300)];
//    
//    [[UIColor blueColor] setFill];
//    
//    [p fill];
    
//    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
//       UIGraphicsEndImageContext();
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:im];
//    imageView.frame=CGRectMake(90, 130, 200, 200);
//    [self addSubview:imageView];
    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    bImageTag = TRUE;
    self.line =[NSMutableArray arrayWithCapacity:0];
    //[self.lines addObject:self.line];
    
    
    
    UITouch *touch=[touches anyObject];
    
    CGPoint point=[touch locationInView:touch.view ];
    NSValue *value=[NSValue valueWithCGPoint:point];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:3];
    
    [dic setValue:line forKey:@"line"];
    [dic setValue:segmentedColor forKey:@"color"];
    
    [self.line addObject:value];
    [self.lines addObject:dic];
    
    
    
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    bImageTag = TRUE;
    label.hidden=YES;
    UITouch *touch=[touches anyObject];
    
    CGPoint point=[touch locationInView:touch.view];
    NSValue *value=[NSValue valueWithCGPoint:point];
    [self.line addObject:value];
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    bImageTag = TRUE;
    UITouch *touch=[touches anyObject];
    
    CGPoint point=[touch locationInView:touch.view];
    NSValue *value=[NSValue valueWithCGPoint:point];
    [self.line addObject:value];
    
    [self setNeedsDisplay];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //获取上下文，上下文的用处，关联下面的函数
    CGContextRef context=UIGraphicsGetCurrentContext();
    //创建一个uicolor
    //UIColor *color=[UIColor redColor];
    //设置画笔颜色，用cgcolor
   // CGContextSetStrokeColorWithColor(context, color.CGColor);
    //设置线宽
    CGContextSetLineWidth(context, 2);
   
    
    
    int b=[self.lines count];
    for (int j=0; j<b; j++) 
    {
        NSDictionary * tempdic=[self.lines objectAtIndex:j];
        UIColor *tempcolor=[tempdic valueForKey:@"color"];
        CGContextSetStrokeColorWithColor(context, tempcolor.CGColor);
        NSArray *temp=[tempdic valueForKey:@"line"];
        
        int a=[temp count]-1;
        for (int i=0; i<a; i++) 
        {
            //设置划线起始位置
            NSValue *point=[temp objectAtIndex:i];
            CGPoint startPoint;
            [point getValue:&startPoint];
            
            CGContextMoveToPoint(context,startPoint.x ,startPoint.y );
            
            
            //设置线段的终点
            NSValue *point1=[temp objectAtIndex:i+1];
            CGPoint endPoint;
            [point1 getValue:&endPoint];
            CGContextAddLineToPoint(context,endPoint.x ,endPoint.y );
            
        }
        //画出线段
        CGContextStrokePath(context);

    }
        
    
    
}
- (void) saveImageToCacheDir:(UIImage *)rect{
    BOOL isDir = NO;
    NSString *imageName=@"test.png";
    NSString *imageType=@"png";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] isDirectory:&isDir];
    bool isSaved = false;
    if ( isDir == YES && existed == YES )
    {
        if ([[imageType lowercaseString] isEqualToString:@"png"])
        {
            isSaved = [UIImagePNGRepresentation(rect) writeToFile:[[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
        }
        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
        {
            isSaved = [UIImageJPEGRepresentation(rect, 1.0) writeToFile:[[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        }
        else
        {
            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
        }
    }
}
- (void)test:(UIImage *)image{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  
  	    // If you go to the folder below, you will find those pictures
       NSLog(@"%@",docDir);
    
       NSLog(@"saving png");
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/test.png",docDir];
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.filename=pngFilePath;
    	    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
    	    [data1 writeToFile:pngFilePath atomically:YES];
}
@end
