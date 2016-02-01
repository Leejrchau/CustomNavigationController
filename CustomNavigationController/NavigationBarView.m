//
//  NavigationBarView.m
//  CustomNavigationController
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 lizhichao. All rights reserved.
//

#import "NavigationBarView.h"

@implementation NavigationBarView

-(id)init
{
    if(self = [super init]){
        
        _backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_backgroundView];
        _backgroundView.backgroundColor =[UIColor whiteColor];
        _navigationBar = [[UINavigationBar alloc]init];
       
        [self addSubview:_navigationBar];
        _navigationBar.barTintColor = [UIColor whiteColor];
        _navigationBar.translucent = YES;
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.5)];
        _lineView.backgroundColor =[UIColor lightGrayColor];
        [self addSubview:_lineView];
        
    }
    return self;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    [_navigationBar sizeToFit];
    CGSize newSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, 64);
    _backgroundView.frame = CGRectMake(0, 0, size.width, 64);
    
    _lineView.frame = CGRectMake(0, self.bounds.size.height-0.5f, self.bounds.size.width, 1.0f);
    return newSize;
}



//-(void)sizeToFit
//{
//    [self sizeThatFits:CGSizeMake([[UIScreen mainScreen]bounds].size.width, 64)];
//    NSLog(@"sdaflsdfkj %@",NSStringFromCGSize(self.bounds.size));
//    
//    [_navigationBar sizeThatFits:CGSizeMake(self.bounds.size.width, 44)];
//    [_backgroundView sizeThatFits:self.bounds.size];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
