//
//  CustomTransitionSegue.h
//  CustomNavigationController
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 lizhichao. All rights reserved.
//

#import <UIKit/UIKit.h>

//转换跳转segue
@interface CustomTransitionSegue : UIStoryboardSegue

//是否是unwind过渡转换
@property(nonatomic,assign)BOOL isUnwind;

@end
