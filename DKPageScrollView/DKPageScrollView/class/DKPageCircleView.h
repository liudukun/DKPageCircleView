//
//  DKPageCircleView.h
//  DKPageCircleView
//
//  Created by imac_ldk on 14-9-16.
//  Copyright (c) 2014年 ldk. All rights reserved.
//

#import <UIKit/UIKit.h>


/// PageControl 的位置

typedef enum : NSUInteger {
    DKPageControlPositionCenter,
    DKPageControlPositionLeft,
    DKPageControlPositionRight,
} DKPageControlPosition;


/// 动画类型

typedef enum : NSUInteger {
    DKAnimationTypePush,//普通左滑右滑
    DKAnimationTypeMoveIn,//覆盖
    DKAnimationTypeFade,//淡入淡出
    DKAnimationTypeCube,//立方体
    DKAnimationTypeSuckEffect,//吮吸
    DKAnimationTypeOglFlip,//翻转
    DKAnimationTypeRippleEffect,//波纹
    DKAnimationTypePageCurl,//翻页
    DKAnimationTypePageUnCurl,//反翻页
} DKAnimationType;

/// 动画方向

typedef enum : NSUInteger {
    DKAnimationSubTypeFromLeft,
    DKAnimationSubTypeFromRight,
    DKAnimationSubTypeFromTop,
    DKAnimationSubTypeFromBottom
} DKAnimationSubType;



@class DKPageCircleView;

@protocol DKPageCircleViewDelegate <NSObject>

@required
/// page 数量
- (NSUInteger)numberOfPages;

/// 设置每一个page
- (UIView *)pageCircleView:(DKPageCircleView *)circleView viewOfIndex:(NSUInteger)index;

@optional

/// page 被选择的时候被调用
- (void)pageCircleView:(DKPageCircleView *)circleView viewSelectedOfIndex:(NSUInteger)index;


@end


@interface DKPageCircleView : UIView

/// page control
@property (nonatomic,strong) UIPageControl * pageControl;

/// timer;
@property (nonatomic,strong) NSTimer *timer;

/// 循环轮播 repeat = yes的时候 所有view 循环播放 .
@property (nonatomic) BOOL repeat;

/** 
    设置自动轮播的时间间隔
    默认 turnTimeInterval = 0
    假如 turnTimeInterval = 0 , 不自动轮播.
 */
@property (nonatomic) NSTimeInterval turnTimeInterval;

/// 设置轮播动画时间
@property (nonatomic) NSTimeInterval turnTime;

/// 设置激活时间  default = 10s
@property (nonatomic) NSTimeInterval activeTime;

/// 代理获取数据,类似 UITableViewDataSourceDelegate 用法
@property (nonatomic,weak) id<DKPageCircleViewDelegate> delegate;

/// set pagecontrol position
@property (nonatomic) DKPageControlPosition pageControlPostion;

/// get and set current index 当前Index
@property (nonatomic) NSInteger currentIndex;

/// set animation type 动画类型
@property (nonatomic) DKAnimationType animationType;

/// set animation sutype 动画方向
@property (nonatomic) DKAnimationSubType animationSubType;

/// random animation
@property (nonatomic) BOOL randomAnimation;

/// lock direction
@property (nonatomic) BOOL lockDirection;


/// 初始化 方法 ,initWithFrame: 默认 animationType = Push default animation subtype = left 
- (instancetype)initWithFrame:(CGRect)frame animationType:(DKAnimationType)animationType animationSubType:(DKAnimationSubType)animationSubType;

/// 加载数据 , 刷新数据
- (void)reloadData;


@end
