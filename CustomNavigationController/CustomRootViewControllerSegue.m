//
//  CustomRootViewControllerSegue.m
//  CustomNavigationController
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 lizhichao. All rights reserved.
//

#import "CustomRootViewControllerSegue.h"
#import "CustomNavigationController.h"

@implementation CustomRootViewControllerSegue

-(void)perform
{
    //当执行一个连接导航堆栈的根视图控制器的segue的时候，这个方法会被调用。
    //这个segue连接的目标对象是导航控制器堆栈中的第一个元素，也是根视图控制器对象。
   //segue的源视图控制器对象是导航控制器对象
    CustomNavigationController *rootNavigationController = self.sourceViewController;
    //当压入根视图控制器对象的时候，创建导航控制器的数组。
    NSArray *viewControllers = @[self.destinationViewController];
    [rootNavigationController setViewControllers:viewControllers];
}

@end
