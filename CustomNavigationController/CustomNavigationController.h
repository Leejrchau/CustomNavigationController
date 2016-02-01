//
//  CustomNavigationController.h
//  CustomNavigationController
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 lizhichao. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
  自定义的导航视图控制器 使用导航控制器的形式一般是两种形式，1 是使用代码调用initWithRootViewController方法。2 是使用storyboard。
 */
@interface CustomNavigationController : UIViewController

@property(nonatomic,readonly,nullable)UIViewController *topViewController;//导航顶部的视图控制器
@property(nonatomic,copy,nullable)NSArray *viewControllers;//模仿导航的堆栈，用来存储导航控制器中管理的视图控制器
@property(nonatomic,getter=isNavigationBarHidden) BOOL navigationBarHidden;
@property(nonatomic,getter=isTooBarHidden) BOOL tooBarHidden;
@property(nullable, nonatomic, weak) id<UINavigationControllerDelegate> delegate;
@property(nonatomic,readonly,nullable) UINavigationBar *navigationBar;
@property(null_resettable,nonatomic,readonly) UIToolbar *toolbar;
@property(nonnull,strong)NSString *rootViewControllerSegueIdentifier;//指向导航根视图控制器的segue的标识符号


- (nullable id)initWithRootViewController:(nullable UIViewController *)rootViewController;

- (void)setViewControllers:(nullable NSArray *)viewControllers animated:(BOOL)animated;

- (void)pushViewController:(nullable UIViewController *)viewController animated:(BOOL)animated;

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;

- (nullable NSArray *)popToViewController:(nullable UIViewController *)viewController animated:(BOOL)animated;

- (nullable NSArray*)popToRootViewControllerAnimated:(BOOL)animated;

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;


@end
