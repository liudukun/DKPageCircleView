# DKPageScrollView
广告栏控件,支持各种动画效果,效率优化


实现方式类似 UITableView 用法 如下:
```
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DKPageCircleView * view = [[DKPageCircleView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    view.turnTimeInterval = 2.f;
    view.turnTime = 1.f;
    view.repeat = YES;
    view.delegate = self;
    view.pageControlPostion = DKPageControlPositionCenter;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    lists = @[@"01.jpg",@"02.jpg",@"01.jpg",@"02.jpg",@"01.jpg",@"02.jpg"];
    view.animationType = DKAnimationTypePageCurl;
    view.animationSubType = DKAnimationSubTypeFromTop;
    view.randomAnimation = YES;
    [view reloadData];
}




/// page 数量
- (NSUInteger)numberOfPages{
    return lists.count;
}

/// 设置每一个page
- (UIView *)pageCircleView:(DKPageCircleView *)circleView viewOfIndex:(NSUInteger)page{
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
- (void)pageCircleView:(DKPageCircleView *)circleView viewSelectedOfIndex:(NSUInteger)index{
    // u code
}

```
