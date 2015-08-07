//
//  FirstViewController.m
//  HandScore
//
//  Created by lyn on 14-5-9.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSTimer *connectionTimer;
    connectionTimer=[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(jump:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) jump:(NSTimer *) timer{
    LoginViewController *loginviewController=[[LoginViewController alloc]init];
   // [self.navigationController pushViewController:loginviewController animated:YES];
    //[self presentViewController:<#(UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>]
    [self presentViewController:loginviewController animated:YES completion:nil];
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//
//{
//    
//    return (toInterfaceOrientation == UIInterfaceOrientationMaskLandscape);
//    
//}

- (BOOL)shouldAutorotate

{
    
    return YES;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskLandscape;//只支持这一个方向(正常的方向)
    
}

//- (BOOL)shouldAutorotate{
//    return NO;
//}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    //return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
//}
@end
