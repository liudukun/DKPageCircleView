//
//  DKPageScrollView.m
//  DKPageScrollView
//
//  Created by imac_ldk on 14-9-16.
//  Copyright (c) 2014年 ldk. All rights reserved.
//

#import "DKPageScrollView.h"

@interface DKView : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;

- (void)loadLastObj;

@end

@implementation DKView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)loadLastObj{
    
}

@end

@interface DKPageScrollView ()<UIScrollViewDelegate>
{
    NSMutableArray * visibleCells;
    NSMutableArray * invisibleCells;
}

@property (nonatomic) CGFloat space;
@property (nonatomic) CGFloat topSpace;
@property (nonatomic) CGFloat subViewWidth;
@end


@implementation DKPageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        visibleCells = [NSMutableArray array];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Array:(NSArray*)array subViewSize:(CGSize)size{
    if (!array.count) {
        return self;
    }
    
    self = [self initWithFrame:frame];
    NSUInteger count = array.count;
    self.contentSize = CGSizeMake(count*(size.width + self.space),self.frame.size.height);
    CGFloat width = frame.size.width;
    int num = width/size.width+1;
    for (int i =0; i<num; i++) {
        id obj = array[i];
        if (obj) {
            DKView* view = (DKView*)obj;
            view.frame  = CGRectMake(i*(size.width + self.space), self.topSpace, view.frame.size.width, view.frame.size.height);
            [self addSubview:view];
            [visibleCells addObject:view];
        }
    }
    DKView * view = [[DKView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [self addSubview:view];
    self.delegate = self;
    
    
    return self;
}


+ (DKPageScrollView*)createPageScrollViewWithArray:(NSArray*)array frame:(CGRect)frame subViewSize:(CGSize)size{
    DKPageScrollView * scrollView = [[DKPageScrollView alloc]initWithFrame:frame Array:array subViewSize:size];
 
    return scrollView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = fabsf(offsetX);
    int distance  = (int)offsetX % (int)self.subViewWidth;
    
    if (distance == self.subViewWidth) {
        DKView * lastCell = visibleCells[visibleCells.count];
        DKView * fristCell = visibleCells[0];
        [fristCell removeFromSuperview];
        
        
        lastCell.frame =  CGRectMake(lastCell.frame.origin.x + lastCell.frame.size.height, self.topSpace, self.subViewWidth,scrollView.frame.size.height);
        [lastCell loadLastObj];
        
    }
    
    
    
}

@end
