//
//  DrawSignView.m
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//
/**
 本界面
 
 */

#import "DrawSignView.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define SYSTEMFONT(x) [UIFont systemFontOfSize:(x)]

@interface DrawSignView ()
@property (strong,nonatomic)  MyView *drawView;
@property (assign,nonatomic)  BOOL buttonHidden;
@property (assign,nonatomic)  BOOL widthHidden;
@end


//保存线条颜色
static NSMutableArray *colors;


@implementation DrawSignView{
    UIButton *redoBtn;//撤销
    UIButton *undoBtn;//恢复
    UIButton *clearBtn;//清空
    UIButton *colorBtn;//颜色
    UIButton *screenBtn;//截屏
    UIButton *widthBtn;//高度
    UIButton *okBtn;//确定并截图返回
    UIButton *cancelBtn;//取消

    UISlider *penBoldSlider;

//    MyView *drawView;//画图的界面，宽高3:1

}

@synthesize signCallBackBlock,cancelBlock;


- (void)dealloc {
    [signCallBackBlock release];
    [cancelBlock release];
    [redoBtn release];
    [undoBtn release];
    [clearBtn release];
    [colorBtn release];
    [screenBtn release];
    [widthBtn release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)createView
{
    CGFloat btn_x = 10;
    CGFloat btn_y = 100;
    CGFloat btn_w = 80;
    CGFloat btn_h = 40;
    CGFloat btn_mid = 5;



    //self
    self.frame = CGRectMake(0, 0, 1000, 500);
    self.backgroundColor = [UIColor colorWithRed:59./255. green:73./255. blue:82./255. alpha:1];
    CALayer *layer = self.layer;
    [layer setCornerRadius:15.0];
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.borderWidth = 1;


    //contentLbl
    UILabel *contentLbl = [[UILabel alloc]init];
    contentLbl.text = @"请在指定区域内签名";
    contentLbl.textAlignment = NSTextAlignmentCenter;
    contentLbl.textColor = [UIColor whiteColor];
    contentLbl.frame = CGRectMake(0, 50, 1000, 50);
    contentLbl.font = [UIFont systemFontOfSize:32.0];
    contentLbl.backgroundColor = [UIColor clearColor];
    [self addSubview:contentLbl];
    [contentLbl release];


    //btns
    redoBtn = [[UIButton alloc]init];
    [self renderBtn:redoBtn];
    [redoBtn setTitle:@"撤销" forState:UIControlStateNormal];
    redoBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    //[self addSubview:redoBtn];
    [redoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    //undoBtn
    undoBtn = [[UIButton alloc]init];
    [self renderBtn:undoBtn];
    [undoBtn setTitle:@"恢复" forState:UIControlStateNormal];
    undoBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    //[self addSubview:undoBtn];
    [undoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    //clearBtn
    clearBtn = [[UIButton alloc]init];
    [self renderBtn:clearBtn];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    clearBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:clearBtn];
     [clearBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    //okBtn
    okBtn = [[UIButton alloc]init];
    [self renderBtn:okBtn];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:okBtn];
    [okBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    //cancelBtn
    cancelBtn = [[UIButton alloc]init];

    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
     [self renderBtn:cancelBtn];
//    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];


    NSMutableArray *btnLArr = [[NSMutableArray alloc]init];
    NSMutableArray *btnRArr = [[NSMutableArray alloc]init];
    //统一设坐标
    [btnLArr addObject:redoBtn];
    [btnLArr addObject:undoBtn];
    //[btnLArr addObject:clearBtn];
    [btnRArr addObject:okBtn];
    [btnRArr addObject:cancelBtn];
    [btnRArr addObject:clearBtn];


    int i = 0;
    for (UIButton *btn in btnLArr) {
        btn.frame = CGRectMake(10, btn_y+ i * (btn_h+btn_mid), btn_w, btn_h);
        i++;
    }
    i = 0;
    for (UIButton *btn in btnRArr) {
        btn.frame = CGRectMake(810, btn_y+ i * (btn_h+btn_mid), btn_w, btn_h);
        i++;
    }

    [btnLArr release];
    [btnRArr release];


    //sliderLbl
    UILabel *sliderLbl = [[UILabel alloc]init];
    sliderLbl.text = @"笔触粗细:";
    sliderLbl.textAlignment = NSTextAlignmentRight;
    sliderLbl.textColor = [UIColor whiteColor];
    sliderLbl.frame = CGRectMake(200, 440, 100, 20);
    sliderLbl.font = [UIFont systemFontOfSize:18.0];
    sliderLbl.backgroundColor = [UIColor clearColor];
    [self addSubview:sliderLbl];
    [sliderLbl release];

    //penBoldSlider
    penBoldSlider = [[UISlider alloc]init];
    penBoldSlider.frame = CGRectMake(300+10, 440, 200, 20);
    penBoldSlider.minimumValue = 0;
    penBoldSlider.maximumValue = 9;
    penBoldSlider.value = 0;
    [penBoldSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:penBoldSlider];

    //
    colors=[[NSMutableArray alloc]initWithObjects:[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor blackColor],[UIColor whiteColor], nil];
    self.buttonHidden=YES;
    self.widthHidden=YES;
    self.drawView=[[MyView alloc]initWithFrame:CGRectMake(200, 100, 600, 300)];
    [self.drawView setBackgroundColor:RGBCOLOR(255, 255, 255)];
    [self addSubview: self.drawView];
    [self sendSubviewToBack:self.drawView];
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)changeColors:(id)sender{
    if (self.buttonHidden==YES) {
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=NO;
            self.buttonHidden=NO;
        }
    }else{
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=YES;
            self.buttonHidden=YES;
        }
    }
}

-(void)changeWidth:(id)sender{
    if (self.widthHidden==YES) {
        for (int i=11; i<15; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=NO;
            self.widthHidden=NO;
        }
    }else{
        for (int i=11; i<15; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=YES;
            self.widthHidden=YES;
        }

    }

}
- (void)widthSet:(id)sender {
    UIButton *button=(UIButton *)sender;
    [self.drawView setlineWidth:button.tag-10];
}

- (UIImage *)saveScreen{

    UIView *screenView = self.drawView;

    for (int i=1; i<16;i++) {
        UIView *view=[self viewWithTag:i];
        if ((i>=1&&i<=5)||(i>=10&&i<=15)) {
            if (view.hidden==YES) {
                continue;
            }
        }
        view.hidden=YES;
        if(i>=1&&i<=5){
            self.buttonHidden=YES;
        }
        if(i>=10&&i<=15){
            self.widthHidden=YES;
        }
    }
    UIGraphicsBeginImageContext(screenView.bounds.size);
    [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(image, screenView, nil, nil);
//    for (int i=1;i<16;i++) {
//        if ((i>=1&&i<=5)||(i>=11&&i<=14)) {
//            continue;
//        }
//        UIView *view=[self viewWithTag:i];
//        view.hidden=NO;
//    }
    NSLog(@"截屏成功");
    //image = [DrawSignView imageToTransparent:image];
    return [[image retain]autorelease];
}

- (void)colorSet:(id)sender {
    UIButton *button=(UIButton *)sender;
    [self.drawView setLineColor:button.tag-1];
    colorBtn.backgroundColor=[colors objectAtIndex:button.tag-1];
}

/** 封装的按钮事件 */
-(void)btnAction:(id)sender{
    if (sender == cancelBtn) {
        cancelBlock();
    }else if (sender == okBtn){
        if ([self.drawView bTag] == YES) {
            signCallBackBlock([self saveScreen]);
        } else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"签名错误" message:@"请先签名在点击确认" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            //signCallBackBlock(nil);
        }
    }else if (sender == redoBtn){
       [ self.drawView revocation];
    }else if(sender == undoBtn){
        [ self.drawView refrom];
    }else if(sender == clearBtn){
        [penBoldSlider setValue:0];
        [self.drawView clear];
    }
}


/** 笔触粗细 */
-(void)updateValue:(id)sender{
    if (sender == penBoldSlider) {
        CGFloat f = penBoldSlider.value;
        NSLog(@"%f",f);
        NSInteger w = (int)ceilf(f);
        [self.drawView setlineWidth:w];
    }
}

/** 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    NSLog(@"release data==========");
    free((void*)data);
}

//颜色替换
+ (UIImage*) imageToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);

    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);

    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {



        //把绿色变成黑色，把背景色变成透明
        if ((*pCurPtr & 0x65815A00) == 0x65815a00)    // 将背景变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else if ((*pCurPtr & 0x00FF0000) == 0x00ff0000)    // 将绿色变成黑色
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
        else if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }

    }

    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);

    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];

    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}


-(void)renderBtn:(UIButton *)btn{
    [btn setBackgroundImage:[self imageFromColor:RGBCOLOR(59,73,82)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageFromColor:RGBCOLOR(169,183,192)]
                   forState:UIControlStateHighlighted];
     double dRadius = 2.0f;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //CornerRadius/Border
    [btn.layer setCornerRadius:dRadius];
    [btn.layer setBorderWidth:1.0f];
    [btn.layer setBorderColor:RGBCOLOR(255, 255, 255).CGColor];
    [btn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];

}

- (UIImage *) imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
