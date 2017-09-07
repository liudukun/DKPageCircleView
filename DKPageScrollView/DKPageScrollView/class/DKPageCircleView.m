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
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeGestureRight;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeGestureLeft;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeGestureUp;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeGestureDown;


@end


@implementation DKPageCircleView


- (instancetype)initWithFrame:(CGRect)frame animationType:(DKAnimationType)animationType animationSubType:(DKAnimationSubType)animationSubType{
    self = [super initWithFrame:frame];
    if (self) {
        self.lockDirection = YES;
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
    cell = [self.delegate pageCircleView:self viewOfIndex:self.currentIndex];
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
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.turnTimeInterval]];
    }
}

- (void)timeRun:(NSTimer *)timer{
    self.currentIndex ++;
    if (self.randomAnimation) {
        self.animationType = arc4random_uniform(8);
        self.animationSubType = arc4random_uniform(3);
    }
    [self reloadCellsAnimation];
}

- (void)reloadCellsAnimation{
    [cell removeFromSuperview];
    cell = [self.delegate pageCircleView:self viewOfIndex:self.currentIndex%numberOfPage];
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
            type = @"fade";
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
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.subtype = subType;
    [view.layer addAnimation:animation forKey:@"transition"];
}

- (void)actionSwipGesture:(UISwipeGestureRecognizer *)swipe{
    
    if (self.animationType == DKAnimationTypeFade ||self.animationType == DKAnimationTypeSuckEffect ||self.animationType == DKAnimationTypeRippleEffect) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft || swipe.direction == UISwipeGestureRecognizerDirectionUp) {
            self.currentIndex --;
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight || swipe.direction == UISwipeGestureRecognizerDirectionDown) {
            self.currentIndex ++;
        }
        
    }
    
    if (self.animationType == DKAnimationTypeCube ||self.animationType == DKAnimationTypeOglFlip ||self.animationType == DKAnimationTypeMoveIn ||self.animationType == DKAnimationTypePush){
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            self.currentIndex --;
            self.animationSubType = DKAnimationSubTypeFromRight;
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            self.currentIndex ++;
            self.animationSubType = DKAnimationSubTypeFromLeft;
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
            self.currentIndex --;
            self.animationSubType = DKAnimationSubTypeFromBottom;
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
            self.currentIndex ++;
            self.animationSubType = DKAnimationSubTypeFromTop;
        }
    }
    
    if (self.animationType == DKAnimationTypePageCurl || self.animationType == DKAnimationTypePageUnCurl) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            self.currentIndex --;
            self.animationType = DKAnimationTypePageUnCurl;
            self.animationSubType = DKAnimationSubTypeFromLeft;
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            self.currentIndex ++;
            self.animationType = DKAnimationTypePageCurl;
            self.animationSubType = DKAnimationSubTypeFromLeft;
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
            self.currentIndex --;
            self.animationType = DKAnimationTypePageUnCurl;
            self.animationSubType = DKAnimationSubTypeFromTop;
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
            self.currentIndex ++;
            self.animationType = DKAnimationTypePageCurl;
            self.animationSubType = DKAnimationSubTypeFromTop;
        }
    }
    [self reloadCellsAnimation];

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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(pageCircleView:viewSelectedOfIndex:)]&&self.delegate) {
        [self.delegate pageCircleView:self viewSelectedOfIndex:self.currentIndex%numberOfPage];
    }
}


#pragma mark - initialize lazy

- (void)createGesture{
    if (self.lockDirection) {
        if ((self.animationSubType == DKAnimationSubTypeFromLeft || self.animationSubType == DKAnimationSubTypeFromRight) && self.lockDirection) {
            [self addGestureRecognizer:self.swipeGestureLeft];
            [self addGestureRecognizer:self.swipeGestureRight];
            [self removeGestureRecognizer:self.swipeGestureDown];
            [self removeGestureRecognizer:self.swipeGestureUp];
        }
        if (self.animationSubType == DKAnimationSubTypeFromTop || self.animationSubType == DKAnimationSubTypeFromBottom) {
            [self addGestureRecognizer:self.swipeGestureUp];
            [self addGestureRecognizer:self.swipeGestureDown];
            [self removeGestureRecognizer:self.swipeGestureDown];
            [self removeGestureRecognizer:self.swipeGestureUp];
        }
    }else{
        [self addGestureRecognizer:self.swipeGestureUp];
        [self addGestureRecognizer:self.swipeGestureDown];
        [self addGestureRecognizer:self.swipeGestureLeft];
        [self addGestureRecognizer:self.swipeGestureRight];
    }

}

- (UISwipeGestureRecognizer *)swipeGestureUp{
    if (_swipeGestureUp) {
        return _swipeGestureUp;
    }
    _swipeGestureUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
    _swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    _swipeGestureUp.delegate = self;
    return _swipeGestureUp;
}

- (UISwipeGestureRecognizer *)swipeGestureLeft{
    if (_swipeGestureLeft) {
        return _swipeGestureLeft;
    }
    _swipeGestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
    _swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    _swipeGestureLeft.delegate = self;
    return _swipeGestureLeft;
}

- (UISwipeGestureRecognizer *)swipeGestureRight{
    if (_swipeGestureRight) {
        return _swipeGestureRight;
    }
    _swipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
    _swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    _swipeGestureRight.delegate = self;
    return _swipeGestureRight;
}

- (UISwipeGestureRecognizer *)swipeGestureDown{
    if (_swipeGestureDown) {
        return _swipeGestureDown;
    }
    _swipeGestureDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSwipGesture:)];
    _swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    _swipeGestureDown.delegate = self;
    return _swipeGestureDown;
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
