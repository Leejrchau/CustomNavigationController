//
//  CustomNavigationController.m
//  CustomNavigationController
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 lizhichao. All rights reserved.
//

#import "CustomNavigationController.h"
#import "CustomRootViewControllerSegue.h"
#import "CustomTransitionSegue.h"
#import "RootViewController.h"
#import "NavigationBarView.h"

@interface CustomNavigationController ()<UINavigationBarDelegate,UIToolbarDelegate>
{
    NSArray *_viewControllers;
    UINavigationBar *_navigationBar;
    UIToolbar *_toolbar;
    NavigationBarView *_navigationBarView;
}
@end

@implementation CustomNavigationController

-(void)loadView
{
    UIView *view = [[UIView alloc]init];
    self.view = view;
    // 1 创建navigationBar
    _navigationBarView = [[NavigationBarView alloc]init];
    _navigationBar = _navigationBarView.navigationBar;
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBarView];
//    _navigationBar = [[UINavigationBar alloc]init];
//    _navigationBar.delegate = self;
//    [self.view addSubview:_navigationBar];

    //创建toolbar
    _toolbar = [[UIToolbar alloc]init];
    _toolbar.delegate = self;
    _toolbar.hidden = YES;
    [self.view addSubview:_toolbar];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(_rootViewControllerSegueIdentifier){
        
        [self performSegueWithIdentifier:_rootViewControllerSegueIdentifier sender:self];
    
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if(self){
        
        if(rootViewController){
            
            NSArray *viewControllersArray = @[rootViewController];
            [self setViewControllers:viewControllersArray];
            _rootViewControllerSegueIdentifier = nil;
            
        }
        
    }
    return self;
}

-(void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    _navigationBar.hidden = navigationBarHidden;
    _navigationBarHidden = navigationBarHidden;
}

-(void)setTooBarHidden:(BOOL)tooBarHidden
{
    _toolbar.hidden = tooBarHidden;
    _tooBarHidden = tooBarHidden;
}


//返回堆栈顶部的视图控制器
-(UIViewController *)topViewController
{
    if(_viewControllers.count>0){
        return [_viewControllers lastObject];
    }
    return nil;
}

-(nullable UINavigationBar *)navigationBar
{
    return  _navigationBar ? _navigationBar:nil;
}

-(UIToolbar *)toolbar
{
    return _toolbar ? _toolbar:nil;
}

//对视图中的子视图布局
-(void)viewDidLayoutSubviews
{
    [_navigationBarView sizeToFit];
    //[_navigationBar sizeToFit];
    [_toolbar sizeToFit];
    CGFloat topLayoutGuide = 0.0f;
    if([self respondsToSelector:@selector(topLayoutGuide)]){
        topLayoutGuide = [self.topLayoutGuide length];
    }
    
    _navigationBarView.frame = CGRectMake(_navigationBarView.frame.origin.x, 0, _navigationBarView.frame.size.width, _navigationBarView.frame.size.height);
    _navigationBar.frame = CGRectMake(_navigationBarView.frame.origin.x, topLayoutGuide, _navigationBarView.frame.size.width, _navigationBar.frame.size.height);
    _navigationBarView.backgroundColor = [UIColor yellowColor];
    
    //_navigationBar.frame = CGRectMake(_navigationBar.frame.origin.x, topLayoutGuide, _navigationBar.frame.size.width, _navigationBar.frame.size.height);
    //_navigationBar.barTintColor = [UIColor yellowColor];
    self.topViewController.view.frame = self.view.bounds;
    
    CGFloat bottomLayoutGuide = 0.0f;
    if([self respondsToSelector:@selector(bottomLayoutGuide)]){
        bottomLayoutGuide = [self.bottomLayoutGuide length];
    }
    _toolbar.frame = CGRectMake(0, bottomLayoutGuide-_toolbar.frame.size.height, _toolbar.frame.size.width, _toolbar.frame.size.height);
}

-(UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
{
    for(UIViewController *vc in [_viewControllers reverseObjectEnumerator]){
        
        if([vc canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender]){
            return vc;
        }
        
    }
    return [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
    CustomTransitionSegue *segue = [[CustomTransitionSegue alloc]initWithIdentifier:identifier source:fromViewController destination:toViewController];
    segue.isUnwind = YES;
    return segue;
}

//获取导航控制器的堆栈数组
-(NSArray *)viewControllers
{
    //我们应该建立一个前提就是 创建导航控制器我们一般也就两种形式 1 通过手写代码调用初始化方法来创建。2 通过storyboard方式来写。
    //如果是通过rootViewController方法获取导航对象的话，那么我们就可以保证_viewControllers  被创建了（因为在这个初始化方法中我们创建了数组对象）。但是如果用户使用的是init方法，或者使用storyboard方式来创建导航的话，那么有可能当程序员获取到导航控制器对象的时候，还没有创建_viewControllers  数组。并且我们不希望用户使用这个数组的时候，得到的是一个空数组。我们希望使用的时候，至少保证这个数组中已经存在一个根视图控制器对象了。 所以我们必须在此强制调用view方法，这样就会再次调用loadView方法，进而会再次调用viewDidLoad方法.
    [self view];
    return _viewControllers;
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    [self setViewControllers:viewControllers animated:NO];
}


// 更新viewControllers数组，并且将压入堆栈的页面加载进来或者要弹出堆栈的页面加载进来
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    //获取压入堆栈的视图页面，(分析得出，在参数viewControllers数组中的，且不在成员变量数组viewControllers中的对象是要压入堆栈的对象)要得到这样一个结果，我们需要使用过滤函数
    
    NSArray *pushViewControllers = [viewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",_viewControllers]];
   
    //pushViewControllers 需要添加到导航的堆栈中
    
    for(UIViewController *vc in pushViewControllers){

        [self addChildViewController:vc];
    }
    
    //此时还不能调用did方法，虽然已经将当前容器视图控制器设为了父视图控制器，但是页面上和堆栈数组中还并没有添加对象。
    
    //定义一个添加完成后的block
    void (^finishAddViewController)() = ^(){
        
        for(RootViewController *vc in pushViewControllers){
            vc.customNavigationController = self;
            [vc didMoveToParentViewController:self];
        }
    
    };
    
    //获取要弹出堆栈的视图页面(分析得出，在成员变量数组中的，且不在参数数组中的是要弹出堆栈的元素)
    
    NSArray *popedViewControllers = [_viewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",viewControllers]];

    //将popedViewControllers 视图页面弹出堆栈
    
    for(UIViewController *vc in popedViewControllers){
        [vc willMoveToParentViewController:nil];
    }
    
    void (^finishRemoveViewController)() = ^(){
    
        for(UIViewController *vc in popedViewControllers){
            [vc removeFromParentViewController];
        }
        
    };
    
    //进行页面上的更改操作
    
    
    UIViewController *oldViewController = _viewControllers.count>0 ? _viewControllers.lastObject : nil;
    UIViewController *newViewController = viewControllers.count>0 ? viewControllers.lastObject : nil;
    
    if(oldViewController!=newViewController){
        
        //如果不一样就要执行动画了
        
        if(oldViewController){
            
            BOOL oldTopViewControllerShouldReterize = oldViewController.view.layer.shouldRasterize;
            oldViewController.view.layer.shouldRasterize = YES;
            [UIView animateWithDuration:(animated) ? 0.25:0 delay:0 options:0 animations:^{
                
                oldViewController.view.alpha = 0.0f;
                
            } completion:^(BOOL finished){
                
                oldViewController.view.layer.shouldRasterize = oldTopViewControllerShouldReterize;
                //将oldViewController的视图从父视图中删除
                [oldViewController.view removeFromSuperview];
                finishRemoveViewController();
                
            }];
            
            
        }else{
            
            finishRemoveViewController();
        }
        
        if(newViewController){
            
            BOOL newTopViewControllerShouldReterize = newViewController.view.layer.shouldRasterize;
            newViewController.view.layer.shouldRasterize = YES;
            
            //[self.view insertSubview:newViewController.view belowSubview:_navigationBarView];
            [self.view addSubview:newViewController.view];
            //始终使_navigationBar处于当前视图的顶部
            [self.view bringSubviewToFront:_navigationBarView];
            newViewController.view.frame = self.view.bounds;
            newViewController.view.alpha = 0.0f;
            
            [UIView animateWithDuration:(animated)?0.25:0.0f delay:(animated)?0.3:0 options:0 animations:^{
                
                newViewController.view.alpha = 1.0f;
            
            } completion:^(BOOL finished){
                
                newViewController.view.layer.shouldRasterize = newTopViewControllerShouldReterize;
                finishAddViewController();
            
            }];
            
            
        }else{
            finishAddViewController();
        }
        
        
        
        
    }else{
        
        //如果一样就没有必要执行动画了
        
        finishAddViewController();
        finishRemoveViewController();
    }
    
    _viewControllers = viewControllers;
    
    NSMutableArray *newNavigationItemsArray = [NSMutableArray arrayWithCapacity:viewControllers.count];
    // 给导航控制器中的每一个视图控制器添加导航item
    for(UIViewController *vc in _viewControllers){
        
        //创建一个视图控制器后，每个控制器会自动创建自己的navigationItem，用于每个控制器能够自定义自己的导航外观。
        [newNavigationItemsArray addObject:vc.navigationItem];
        
    }
    //将每个子视图控制器的导航item添加到导航栏中管理
    [_navigationBar setItems:newNavigationItemsArray animated:animated];
    
}

- (void)pushViewController:(nullable UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController){
        
        //首先确定要压入堆栈的viewController对象是否有值
        //如果确定有值，那么就把这个视图控制器对象添加到数组中
        NSArray *newArray = [_viewControllers arrayByAddingObject:viewController];
        if(animated){
            
            [self setViewControllers:newArray animated:animated];
            
        }else{
            
            //这里才是更改_viewControllers数组对象
            [self setViewControllers:newArray];
            
        }

    }
}

// 将堆栈顶部的视图控制器弹出
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //将viewControllers数组中的顶部视图控制器弹出栈
    NSUInteger counts = _viewControllers.count;
    if(counts>0){
        
        //先获取要弹出去的视图控制器对象
        UIViewController *viewController = [_viewControllers lastObject];
        //接下来我们要更改viewControler数组的数据
        // 首先要获取经过更新操作后的数据对象（注意此时，_viewControllers数组还没有发生变化）
        NSArray *subArray = [_viewControllers subarrayWithRange:NSMakeRange(0, counts-1)];
        if(animated){
            
            [self setViewControllers:subArray animated:animated];
            
        }else{
            
            //这里才是更改_viewControllers数组对象
            [self setViewControllers:subArray];
 
        }
        
        return viewController;
    }
    return nil;
}

//将堆栈弹到指定的视图控制器页面上
- (nullable NSArray *)popToViewController:(nullable UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger counts = _viewControllers.count;
    if(counts>0){
        
        // 执行到这里说明 _veiwControllers 数组中肯定有对象
        //先判断viewController
        NSUInteger index = [_viewControllers indexOfObject:viewController];
        if(index == NSNotFound){
            
            return nil;
        }
        NSArray *popedArray = [_viewControllers subarrayWithRange:NSMakeRange(index+1, counts-index-1)];
        
        NSArray *subArray = [_viewControllers subarrayWithRange:NSMakeRange(0, index+1)];
        if(animated){
            
            [self setViewControllers:subArray animated:animated];
            
        }else{
            
            //这里才是更改_viewControllers数组对象
            [self setViewControllers:subArray];
            
        }

        return popedArray;
    }
    return nil;
}

//将堆栈直接弹到根视图控制器对象,返回值是弹出去的对象组成的数组
- (nullable NSArray*)popToRootViewControllerAnimated:(BOOL)animated
{
    NSUInteger counts = _viewControllers.count;
    //如果是弹到根视图控制器的话绝对不能根据0来判断，因为系统的导航控制器的根视图控制器是无法弹出的，也就是说系统的导航堆栈中至少保留根视图控制器对象
    if(counts>1){
        
        UIViewController *rootViewController = [_viewControllers firstObject];
        //调用跳转到堆栈中指定的视图控制器的方法
        return  [self popToViewController:rootViewController animated:animated];
        
    }
    //如果不是大于1说明是<=1 那么就返回nil
    return nil;
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    _navigationBarHidden = hidden;
    _navigationBar.hidden = hidden;
}


-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self popViewControllerAnimated:YES];
    return YES;
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
