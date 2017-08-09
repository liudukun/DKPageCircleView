//
//  DKTestViewController.m
//  DKPageScrollView
//
//  Created by imac_ldk on 14-9-16.
//  Copyright (c) 2014年 ldk. All rights reserved.
//

#import "DKTestViewController.h"
#import "DKPageScrollView.h"


@interface DKTestViewController ()<DKPageScrollViewDelegate>
{
    NSArray * lists;
}
@end

@implementation DKTestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DKPageScrollView * view = [[DKPageScrollView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    view.turnTimeInterval = 2.f;
    view.turnTime = 1.f;
    view.repeat = YES;
    view.delegate = self;
    view.pageControlPostion = DKPageControlPositionCenter;
    view.scrollDirection = DKScrollDirectionHoriontal;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    lists = @[@"01.jpg",@"02.jpg",@"01.jpg",@"02.jpg",@"01.jpg",@"02.jpg"];
    view.animationType = DKAnimationTypeNormal;
//    view.animationSubType = kCATransitionFromLeft;
    [view reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// page 数量
- (NSUInteger)numberOfPages{
    return lists.count;
}

/// 设置每一个page
- (UIView *)pageScrollView:(DKPageScrollView *)pageScroll viewOfPage:(NSUInteger)page{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.image = [UIImage imageNamed:lists[page]];
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont systemFontOfSize:25];
    l.text = [@(page) stringValue];
    [view addSubview:l];
    return view;
}

/// page 被选择的时候被调用
- (void)pageScrollView:(DKPageScrollView *)pageScroll viewSelectedOfPage:(NSUInteger)page{
    
}


@end
