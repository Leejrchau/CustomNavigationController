//
//  NavigationBarView.h
//  CustomNavigationController
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 lizhichao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBarView : UIView
{
    UIView *_lineView;
}
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UINavigationBar *navigationBar;

@end
