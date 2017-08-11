//
//  DKPageCircleView.m
//  DKPageCircleView
//
//  Created by imac_ldk on 14-9-16.
//  Copyright (c) 2014年 ldk. All rights reserved.
//

#import "DKPageCircleView.h"


@interface DKPageCircleView ()<UIGestureRecognizerDelegate>
{
    NSUInteger numberOfPage;
    UIView *cell;
}
@property (nonatomic,strong) UIView *contentView;

@end


@implementation DKPageCircleView


- (instancetype)initWithFrame:(CGRect)frame animationType:(DKAnimationType)animationType animationSubType:(DKAnimationSubType)animationSubType{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationType = animationType;
        self.animationSubType = animationSubType;
        self.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame animationType:DKAnimationTypePush animationSubType:DKAnimationSubTypeFromLeft];
}

- (void)reloadData{
    [self createGesture];
    numberOfPage = [self.delegate numberOfPages];
    
    //scrollview
    cell = [self.delegate pageScrollView:self viewOfPage:self.currentIndex];
    cell.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.contentView addSubview:cell];
    
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

- (void)timeRun:(NSTimer *)timer{
    self.currentIndex ++;
    [self reloadCellsAnimation];
}

- (void)reloadCellsAnimation{
    [cell removeFromSuperview];
    cell = [self.delegate pageScrollView:self viewOfPage:self.currentIndex%numberOfPage];
    cell.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.contentView addSubview:cell];
    [self transitionForView:self.contentView];
    self.pageControl.currentPage = self.currentIndex%numberOfPage;
}

- (void)transitionForView:(UIView *)view
{
    NSString *type = @"push";
    NSString *subType = @"fromLeft";
    switch (self.animationType) {
        case DKAnimationTypePush:
            type = @"push";
            break;
        case DKAnimationTypeMoveIn:
            type = @"moveIn";
            break;
        case DKAnimationTypeFade:
            type = @"fademoveIn";
            break;
        case DKAnimationTypeCube:
            type = @"cube";
            break;
        case DKAnimationTypeSuckEffect:
            type = @"suckEffect";
            break;
        case DKAnimationTypeOglFlip:
            type = @"oglFlip";
            break;
        case DKAnimationTypeRippleEffect:
            type = @"rippleEffect";
            break;
        case DKAnimationTypePageCurl:
            type = @"pageCurl";
            break;
        case DKAnimationTypePageUnCurl:
            type = @"pageUnCurl";
            break;
        default:
            break;
    }
    switch (self.animationSubType) {
        case DKAnimationSubTypeFromLeft:
            subType = @"fromLeft";
            break;
        case DKAnimationSubTypeFromRight:
            subType = @"fromRight";
            break;
        case DKAnimationSubTypeFromTop:
            subType = @"fromTop";
            break;
        case DKAnimationSubTypeFromBottom:
            subType = @"fromBottom";
            break;
        default:
            break;
    }
    CATransition *animation = [CATransition animation];
    animation.type = type;
    animation.duration = self.turnTime;
    animation.subtype = subType;
    [view.layer addAnimation:animation forKey:@"transition"];
}

- (void)actionSwipGesture:(UISwipeGestureRecognizer *)swipe{
    
    if (self.animationType == DKAnimationTypeFade ||self.animationType == DKAnimationTypeSuckEffect ||self.animationType == DKAnimationTypeRippleEffect) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            self.currentIndex --;
            [self reloadCellsAnimation];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            self.currentIndex ++;
            [self reloadCellsAnimation];
        }
    }
    
    if (self.animationType == DKAnimationTypeCube ||self.animationType == DKAnimationTypeOglFlip ||self.animationType == DKAnimationTypeMoveIn ||self.animationType == DKAnimationTypePush){
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            self.currentIndex --;
            self.animationSubType = DKAnimationSubTypeFromRight;
            [self reloadCellsAnimation];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            self.currentIndex ++;
            self.animationSubType = DKAnimationSubTypeFromLeft;
            [self reloadCellsAnimation];
        }
    }
    
    if (self.animationType == DKAnimationTypePageCurl || self.animationType == DKAnimationTypePageUnCurl) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            self.currentIndex --;
            self.animationType = DKAnimationTypePageUnCurl;
            self.animationSubType = DKAnimationSubTypeFromLeft;
            [self reloadCellsAnimation];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            self.currentIndex ++;
            self.animationType = DKAnimationTypePageCurl;
            self.animationSubType = DKAnimationSubTypeFromLeft;
            [self reloadCellsAnimation];
        }
    }
    
}

- (void)pauseTimerAndRunAfterTenSec{
    [self.timer setFireDate:[NSDate distantFuture]];
    NSDate *future = [NSDate dateWithTimeIntervalSinceNow:self.activeTime];
    [self.timer setFireDate:future];
}

#pragma mark - gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        [self pauseTimerAndRunAfterTenSec];
    }
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(pageScrollView:viewSelectedOfPage:)]&&self.delegate) {
        [self.delegate pageScrollView:self viewSelectedOfPage:self.currentIndex%numberOfPage];
    }
}


#pragma mark - initialize lazy

- (void)createGesture{
    if (self.animationSubType == DKAnimationSubTypeFromLeft || self.animationSubType == DKAnimationSubTypeFromRight) {
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
        swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        swipeGestureRight.delegate = self;
        [self addGestureRecognizer:swipeGestureRight];
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeGestureLeft.delegate = self;
        [self addGestureRecognizer:swipeGestureLeft];
    }
    if (self.animationSubType == DKAnimationSubTypeFromTop || self.animationSubType == DKAnimationSubTypeFromBottom) {
        UISwipeGestureRecognizer *swipeGestureTop = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
        swipeGestureTop.direction = UISwipeGestureRecognizerDirectionRight;
        swipeGestureTop.delegate = self;
        [self addGestureRecognizer:swipeGestureTop];
        
        UISwipeGestureRecognizer *swipeGestureBottom = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
        swipeGestureBottom.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeGestureBottom.delegate = self;
        [self addGestureRecognizer:swipeGestureBottom];
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

- (DKAnimationType)animationType{
    if (_animationType) {
        return _animationType;
    }
    return DKAnimationTypePush;
}

- (DKAnimationSubType)animationSubType{
    if (_animationSubType) {
        return _animationSubType;
    }
    return DKAnimationSubTypeFromLeft;
}

- (NSTimeInterval)activeTime{
    if (_activeTime) {
        return _activeTime;
    }
    return 10.f;
}

- (UIView *)contentView{
    if (_contentView) {
        return _contentView;
    }
    _contentView = [[UIView alloc]initWithFrame:self.bounds];
    return _contentView;
}

@end
