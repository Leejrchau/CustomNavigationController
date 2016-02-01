//
//  ContentViewController.m
//  CustomNavigationController
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 lizhichao. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"view %@",NSStringFromCGRect(self.view.frame));
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,1, 200, 95)];
//    label.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:label];
    
    //视图是否延伸至bar所在的区域
    //self.extendedLayoutIncludesOpaqueBars = NO;
    //这个属性设置：当视图的四周有bar时，设置上下左右哪个边扩展到屏幕的边缘，这里我们设置的是只让底部，左，右扩展到屏幕的边缘，上不不扩展到屏幕的边缘。默认是四周都扩展到边缘
    
    //self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    

    self.view.backgroundColor = [UIColor whiteColor];
    
   
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"daoru" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(daoRu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //self.navigationController.toolbarHidden = NO;
    
    // Do any additional setup after loading the view.
}

-(void)daoRu
{
    RootViewController *root = [[ContentViewController alloc]init];
    [self.customNavigationController pushViewController:root animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
