//
//  DKPageScrollView.h
//  DKPageScrollView
//
//  Created by imac_ldk on 14-9-16.
//  Copyright (c) 2014年 ldk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PageScrollViewStyleNormal,
    PageScrollViewStyleSpecail
} PageScrollViewStyle;


@class DKPageScrollViewCell;

@protocol DKPageScrollViewCellDelegate <NSObject>

- (void)pageScrollViewActionTouched:(DKPageScrollViewCell*)cell index:(int)index;

@end

@protocol DKPageScrollViewDelegate <NSObject>

- (void)pageScrollViewActionTouched:(DKPageScrollViewCell*)cell index:(int)index;

@end


@interface DKPageScrollView : UIView
@property  (nonatomic,strong) NSMutableArray * cells;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic) CGSize cellSize;
@property (nonatomic,strong) id<DKPageScrollViewDelegate> delegate;
@property (nonatomic,strong) UIPageControl * pageControl;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic) PageScrollViewStyle style;

- (void)switchPage;
+ (DKPageScrollView*)pageScrollViewWithNumberOfCells:(int)number frame:(CGRect)frame cellSize:(CGSize)size;

- (void)addImagesWithPics:(NSArray*)pic;

- (void)addImagesWithPicUrls:(NSArray*)urls;

@end
