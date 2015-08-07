//
//  TestViewController.m
//  PopoverController
//
//  Created by lcc on 12-12-3.
//  Copyright (c) 2012年 lcc. All rights reserved.
//

#import "TestViewController.h"

#import "ScoreTableViewController.h"
#import "TYAppDelegate.h"
@interface TestViewController ()

@end

@implementation TestViewController
@synthesize scorecell;
static NSString *CellTalbeIdentifier=@"CellTableIdentifier";
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
    // self.comboBoxDatasource = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comboBoxDatasource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ListCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.textLabel.text = (NSString *)[self.comboBoxDatasource objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 25.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *aa = (NSString *)[self.comboBoxDatasource objectAtIndex:indexPath.row];
   
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
//    if(delegate.update1==nil){
//        delegate.update1=[NSMutableArray arrayWithCapacity:100];
//    }
    delegate.stringvalue=aa;
    [self.poc dismissPopoverAnimated:NO];
    self.getscore.text=aa;
       // _getscore.text=delegate.stringvalue;
    NSMutableArray *newarray;
    if(delegate.update==nil){
        newarray = [self.Datasource mutableCopy];
    }else{
        newarray=[delegate.update mutableCopy];
    }
    
    // NSMutableArray *newarray = [_computers mutableCopy];
    NSMutableDictionary *rowData=newarray[_bb];
    NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
    [rowData1 setObject:rowData[@"MSI_Item"] forKey:@"MSI_Item"];
    [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
    [rowData1 setObject:rowData[@"MSI_ItemName"] forKey:@"MSI_ItemName"];
    //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
    NSLog(@"%d",_oo);
       NSLog(@"%@",delegate.update1);
    if(rowData[@"GetScore"]==nil){
        _arrat2=[NSMutableDictionary dictionary];
        
    }else{
        _arrat2=rowData[@"GetScore"];
    }

    [_arrat2 setObject:aa forKey:[NSString stringWithFormat:@"%d",_oo]];
 
    [rowData1 setObject:_arrat2 forKey:@"GetScore"];
    [newarray replaceObjectAtIndex:_bb withObject:rowData1];
    delegate.update=newarray;
  // ScoreTableViewController *scoretableviewcontroller=[[ScoreTableViewController alloc]init];
//    [scoretableviewcontroller.tableview reloadData];
   // Scorecell *aaa=[[Scorecell alloc]init];
   // UITextField *textfield=(id)[aaa.self viewWithTag:_oo+1];
    //textfield.text=self.comboBoxDatasource[_oo];
    }

@end
