//
//  DKPageScrollView.h
//  DKPageScrollView
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

/// Scorll direction
typedef enum : NSUInteger {
    DKScrollDirectionHoriontal,
    DKScrollDirectionVertical
} DKScrollDirection;

/// turn style
typedef enum : NSUInteger {
    DKTurnSyleHoriontal,
    DKTurnSyleVertical
} DKTurnSyle;


UIKIT_EXTERN NSString* const DKAnimationTypePush;                     //普通左滑右滑
UIKIT_EXTERN NSString* const DKAnimationTypeMoveIn;                     //覆盖
UIKIT_EXTERN NSString* const DKAnimationTypeFade;                       //淡入淡出
UIKIT_EXTERN NSString* const DKAnimationTypeCube;                       //立方体
UIKIT_EXTERN NSString* const DKAnimationTypeSuckEffect;                 //吮吸
UIKIT_EXTERN NSString* const DKAnimationTypeOglFlip;                    //翻转
UIKIT_EXTERN NSString* const DKAnimationTypeRippleEffect;               //波纹
UIKIT_EXTERN NSString* const DKAnimationTypePageCurl;                   //翻页
UIKIT_EXTERN NSString* const DKAnimationTypePageUnCurl;                 //反翻页



@class DKPageScrollView;

@protocol DKPageScrollViewDelegate <NSObject>

@required
/// page 数量
- (NSUInteger)numberOfPages;

/// 设置每一个page
- (UIView *)pageScrollView:(DKPageScrollView *)pageScroll viewOfPage:(NSUInteger)page;

@optional

/// page 被选择的时候被调用
- (void)pageScrollView:(DKPageScrollView *)pageScroll viewSelectedOfPage:(NSUInteger)page;


@end


@interface DKPageScrollView : UIView

/// page control
@property (nonatomic,strong) UIPageControl * pageControl;

/// timer;
@property (nonatomic,strong) NSTimer *timer;

/// 循环轮播 repeat = yes的时候 所有view 循环播放,没有尽头.
@property (nonatomic) BOOL repeat;

/** 
    设置自动轮播的时间间隔
    默认 turnTimeInterval = 0
    假如 turnTimeInterval = 0 , 不自动轮播.
 */
@property (nonatomic) NSTimeInterval turnTimeInterval;

/// 设置轮播动画时间
@property (nonatomic) NSTimeInterval turnTime;

//// 设置激活时间  default = 10s
@property (nonatomic) NSTimeInterval activeTime;

@property (nonatomic,weak) id<DKPageScrollViewDelegate> delegate;

/// set pagecontrol position
@property (nonatomic) DKPageControlPosition pageControlPostion;

/// set Scroll Direction
@property (nonatomic) DKScrollDirection scrollDirection;


/// get and set current index 当前Index
@property (nonatomic) NSInteger currentIndex;

/// set animation type 动画类型
@property (nonatomic,strong) NSString *animationType;

/// set animation sutype 动画方向
@property (nonatomic,strong) NSString *animationSubType;

- (instancetype)initWithFrame:(CGRect)frame animationType:(NSString *)animationType;

- (void)reloadData;

@end
