//
//  DKPageScrollView.m
//  DKPageScrollView
//
//  Created by imac_ldk on 14-9-16.
//  Copyright (c) 2014年 ldk. All rights reserved.
//

#import "DKPageScrollView.h"

NSString* const DKAnimationTypeNormal = nil;                //普通左滑右滑
NSString* const DKAnimationTypeFade  = @"fade";                 //淡入淡出
NSString* const DKAnimationTypeCube = @"cube";                       //立方体
NSString* const DKAnimationTypeSuckEffect = @"suckEffect";                 //吮吸
NSString* const DKAnimationTypeOglFlip = @"oglFlip";                    //翻转
NSString* const DKAnimationTypeRippleEffect = @"rippleEffect";               //波纹
NSString* const DKAnimationTypePageCurl = @"pageCurl";                   //翻页
NSString* const DKAnimationTypePageUnCurl = @"pageUnCurl";                //反翻页
NSString* const DKAnimationTypeMoveIn = @"moveIn";



@interface DKPageScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSUInteger numberOfPage;
    NSMutableArray *cells;
    UISwipeGestureRecognizer *swipeGestureRight;
    UISwipeGestureRecognizer *swipeGestureLeft;
}

@end


@implementation DKPageScrollView


- (instancetype)initWithFrame:(CGRect)frame animationType:(NSString *)animationType{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationType = animationType;
        if (!animationType) {
            [self addSubview:self.scrollView];
        }
        [self addSubview:self.pageControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame animationType:DKAnimationTypeNormal];
}

- (void)reloadData{
    //scrollview
    cells = [NSMutableArray array];
    numberOfPage = [self.delegate numberOfPages];
    if (self.animationType) {
        [self createGesture];
        UIView *cell = [self.delegate pageScrollView:self viewOfPage:self.currentIndex];
        cell.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:cell];
    }else{
        for (int i = 0; i < 3; i ++) {
            UIView *cell = [self.delegate pageScrollView:self viewOfPage:i];
            if (self.scrollDirection == DKScrollDirectionHoriontal) {
                cell.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
            }else{
                cell.frame = CGRectMake(0, self.frame.size.height * i, self.frame.size.width, self.frame.size.height);
            }
            [self.scrollView addSubview:cell];
            [cells addObject:cell];
        }
        self.currentIndex = 1;
        if (self.scrollDirection == DKScrollDirectionHoriontal) {
            self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
            [self reloadCellsScrollHoriontal];

        }else{
            self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 3);
            [self reloadCellsScrollVertical];
        }
    }
    
    //pagecontrol
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:numberOfPage];
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - pageControlSize.height, pageControlSize.width, pageControlSize.height);
    [self setPageControlPostion:_pageControlPostion];
    self.pageControl.numberOfPages = numberOfPage;
    
    //timer
    if (!self.turnTimeInterval) {
        [self.timer invalidate];
        self.timer = nil;
    }else{
        [self.timer fire];
    }
    
    
}

- (void)reloadCellsScrollVertical{
    //left load
    CGFloat offX = self.scrollView.contentOffset.y;
    if (offX == 0) {
        [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = cell.frame;
            rect.origin.y += self.frame.size.height;
            cell.frame = rect;
        }];
        
        NSInteger insertIndex = self.currentIndex - 2;
        if (insertIndex < 0) {
            insertIndex = numberOfPage + insertIndex;
        }
        
        self.currentIndex --;
        if (self.currentIndex < 0 ) {
            self.currentIndex = numberOfPage + self.currentIndex;
        }
        self.currentIndex = self.currentIndex %numberOfPage;
        
        UIView *insertCell = [self.delegate pageScrollView:self viewOfPage:insertIndex %numberOfPage];
        insertCell.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.scrollView addSubview:insertCell];
        
        [cells insertObject:insertCell atIndex:0];
        if (cells.count > 3) {
            [cells removeObject:cells.lastObject];
        }
    }
    
    //right load
    if (offX == self.scrollView.frame.size.height * 2) {
        [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = cell.frame;
            rect.origin.y -= self.frame.size.height;
            cell.frame = rect;
        }];
        
        NSInteger insertIndex = self.currentIndex + 2;
        if (insertIndex < 0) {
            insertIndex = numberOfPage + insertIndex;
        }
        
        self.currentIndex ++;
        if (self.currentIndex < 0 ) {
            self.currentIndex = numberOfPage + self.currentIndex;
        }
        self.currentIndex = self.currentIndex %numberOfPage;
        
        UIView *insertCell = [self.delegate pageScrollView:self viewOfPage:insertIndex %numberOfPage];
        insertCell.frame = CGRectMake(0, self.frame.size.height * 2, self.frame.size.width, self.frame.size.height);
        [self.scrollView addSubview:insertCell];
        
        [cells insertObject:insertCell atIndex:2];
        if (cells.count >3) {
            [cells removeObject:cells.firstObject];
        }
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, self.frame.size.height)];
    self.pageControl.currentPage = self.currentIndex%numberOfPage;
}

- (void)reloadCellsScrollHoriontal{
    //left load
    CGFloat offX = self.scrollView.contentOffset.x;
    if (offX == 0) {
        [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = cell.frame;
            rect.origin.x += self.frame.size.width;
            cell.frame = rect;
        }];
        
        NSInteger insertIndex = self.currentIndex - 2;
        if (insertIndex < 0) {
            insertIndex = numberOfPage + insertIndex;
        }
        
        self.currentIndex --;
        if (self.currentIndex < 0 ) {
            self.currentIndex = numberOfPage + self.currentIndex;
        }
        self.currentIndex = self.currentIndex %numberOfPage;
        
        UIView *insertCell = [self.delegate pageScrollView:self viewOfPage:insertIndex %numberOfPage];
        insertCell.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.scrollView addSubview:insertCell];
        
        [cells insertObject:insertCell atIndex:0];
        if (cells.count > 3) {
            [cells removeObject:cells.lastObject];
        }
    }
    
    //right load
    if (offX == self.scrollView.frame.size.width * 2) {
        [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = cell.frame;
            rect.origin.x -= self.frame.size.width;
            cell.frame = rect;
        }];
        
        NSInteger insertIndex = self.currentIndex + 2;
        if (insertIndex < 0) {
            insertIndex = numberOfPage + insertIndex;
        }
        
        self.currentIndex ++;
        if (self.currentIndex < 0 ) {
            self.currentIndex = numberOfPage + self.currentIndex;
        }
        self.currentIndex = self.currentIndex %numberOfPage;
        
        UIView *insertCell = [self.delegate pageScrollView:self viewOfPage:insertIndex %numberOfPage];
        insertCell.frame = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height);
        [self.scrollView addSubview:insertCell];
        
        [cells insertObject:insertCell atIndex:2];
        if (cells.count >3) {
            [cells removeObject:cells.firstObject];
        }
    }
    
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    self.pageControl.currentPage = self.currentIndex%numberOfPage;
}

- (void)reloadCellsScroll{
    if(self.scrollDirection == DKScrollDirectionHoriontal){
        [self reloadCellsScrollHoriontal];
    }else{
        [self reloadCellsScrollVertical];
    }
}

- (void)timeRun:(NSTimer *)timer{
    if ([self.animationType isEqualToString:DKAnimationTypeNormal]) {
        [UIView animateWithDuration:self.turnTime animations:^{
            if(self.scrollDirection == DKScrollDirectionHoriontal){
                [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0)];
            }else{
                [self.scrollView setContentOffset:CGPointMake(0, self.frame.size.height * 2)];
            }
        } completion:^(BOOL finished) {
            [self reloadCellsScroll];
        }];
    }else{
        self.currentIndex ++;
        [self reloadCellsAnimation];
    }
    
}

- (void)reloadCellsAnimation{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UIView *cell = [self.delegate pageScrollView:self viewOfPage:self.currentIndex%numberOfPage];
    cell.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.scrollView addSubview:cell];
    [self transitionForView:cell];
    self.pageControl.currentPage = self.currentIndex%numberOfPage;
}

- (void)transitionForView:(UIView *) view
{
    CATransition *animation = [CATransition animation];
    animation.type = self.animationType;
    animation.duration = self.turnTime;
    animation.subtype = self.animationSubType;
    [self.layer addAnimation:animation forKey:@"animation"];
}

- (void)actionSwipGesture:(UISwipeGestureRecognizer *)swipe{
    
    if ([self.animationType isEqualToString:DKAnimationTypeFade] || [self.animationType isEqualToString:DKAnimationTypeSuckEffect] || [self.animationType isEqualToString:DKAnimationTypeRippleEffect]) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            self.currentIndex --;
            [self reloadCellsAnimation];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            self.currentIndex ++;
            [self reloadCellsAnimation];
        }
    }
    
    if ([self.animationType isEqualToString:DKAnimationTypeCube] || [self.animationType isEqualToString:DKAnimationTypeOglFlip] ||[self.animationType isEqualToString:DKAnimationTypeMoveIn]) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            self.currentIndex --;
            self.animationSubType = kCATransitionFromRight;
            [self reloadCellsAnimation];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            self.currentIndex ++;
            self.animationSubType = kCATransitionFromLeft;
            [self reloadCellsAnimation];
        }
    }
    
    
    if ([self.animationType isEqualToString:DKAnimationTypePageCurl] || [self.animationType isEqualToString:DKAnimationTypePageUnCurl]) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            self.currentIndex --;
            self.animationType = DKAnimationTypePageUnCurl;
            self.animationSubType = kCATransitionFromLeft;
            [self reloadCellsAnimation];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            self.currentIndex ++;
            self.animationType = DKAnimationTypePageCurl;
            self.animationSubType = kCATransitionFromLeft;
            [self reloadCellsAnimation];
        }
    }
    
}

- (void)pauseTimerAndRunAfterTenSec{
    [self.timer setFireDate:[NSDate distantFuture]];
    NSDate *future = [NSDate dateWithTimeIntervalSinceNow:self.activeTime];
    [self.timer setFireDate:future];
}

#pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self pauseTimerAndRunAfterTenSec];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self reloadCellsScroll];
}

#pragma mark - gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (gestureRecognizer == swipeGestureRight || gestureRecognizer == swipeGestureLeft) {
        [self pauseTimerAndRunAfterTenSec];
    }
    return YES;
}


#pragma mark - initialize lazy

- (void)createGesture{
    if (!swipeGestureRight&&!swipeGestureLeft) {
        swipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
        swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        swipeGestureRight.delegate = self;
        [self addGestureRecognizer:swipeGestureRight];
        
        swipeGestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeGestureLeft.delegate = self;
        [self addGestureRecognizer:swipeGestureLeft];
    }
}

- (NSTimeInterval)turnTime{
    if (_turnTime) {
        return _turnTime;
    }
    return 0.5;
}

- (NSTimer *)timer{
    if (_timer) {
        return _timer;
    }
    _timer = [NSTimer timerWithTimeInterval:self.turnTimeInterval target:self selector:@selector(timeRun:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    return _timer;
}

- (void)setPageControlPostion:(DKPageControlPosition)pageControlPostion{
    _pageControlPostion = pageControlPostion;
    CGRect rect = self.pageControl.frame;
    switch (pageControlPostion) {
        case DKPageControlPositionLeft:
            rect.origin.x = 20;
            break;
        case DKPageControlPositionCenter:
            rect.origin.x = (self.frame.size.width - self.pageControl.frame.size.width)/2 ;
            break;
        case DKPageControlPositionRight:
            rect.origin.x = self.frame.size.height - self.pageControl.frame.size.width;
            break;
            
        default:
            break;
    }
    self.pageControl.frame = rect;
}

- (UIPageControl *)pageControl{
    if (_pageControl) {
        return _pageControl;
    }
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 0, 37)];
    _pageControl.numberOfPages = 0;
    return _pageControl;
}

- (UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    return _scrollView;
}

- (NSString *)animationType{
    if (_animationType) {
        return _animationType;
    }
    return DKAnimationTypeNormal;
}

- (NSString *)animationSubType{
    if (_animationSubType) {
        return _animationSubType;
    }
    return kCATransitionFromLeft;
}

- (NSTimeInterval)activeTime{
    if (_activeTime) {
        return _activeTime;
    }
    return 10.f;
}

@end
