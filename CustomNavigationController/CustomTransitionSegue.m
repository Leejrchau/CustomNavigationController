//
//  CustomTransitionSegue.m
//  CustomNavigationController
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 lizhichao. All rights reserved.
//

#import "CustomTransitionSegue.h"
#import "CustomNavigationController.h"

@implementation CustomTransitionSegue

-(void)perform
{
    //获取segue的目标视图控制器
    UIViewController *viewController = self.destinationViewController;
    //获取导航视图控制器
    CustomNavigationController *customNavigationController = (CustomNavigationController *)[self.sourceViewController parentViewController];

    if(self.isUnwind){
        
            //跳转到目标视图控制器(以出栈的形式，跳转到目标视图控制器)
        [customNavigationController popToViewController:viewController animated:YES];
        
    }else{
        //以压栈的形式，跳转到目标视图控制器
        [customNavigationController pushViewController:viewController animated:YES];
    }
}

@end
