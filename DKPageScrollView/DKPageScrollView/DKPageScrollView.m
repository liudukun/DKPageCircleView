//
//  DKPageScrollView.m
//  DKPageScrollView
//
//  Created by imac_ldk on 14-9-16.
//  Copyright (c) 2014年 ldk. All rights reserved.
//

#import "DKPageScrollView.h"



@interface DKPageScrollViewCell : UIView

@property (nonatomic) int index;
@property (nonatomic,strong) id<DKPageScrollViewCellDelegate> delegate;

@end

@implementation DKPageScrollViewCell

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate pageScrollViewActionTouched:self index:self.index];
}

@end



@interface DKPageScrollView ()<DKPageScrollViewCellDelegate,UIScrollViewDelegate>
{
    int temp;
}

@end


@implementation DKPageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // Initialization code
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.scrollView];
        self.userInteractionEnabled = YES;
        self.scrollView.pagingEnabled = YES;
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height *0.9, self.frame.size.width*0.5, self.frame.size.height*0.1)];
        self.pageControl.center = CGPointMake(self.scrollView.frame.size.width/2.0, self.pageControl.center.y);
        self.pageControl.tintColor = [UIColor blueColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self addSubview:self.pageControl];
        self.scrollView.delegate = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(switchPage) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate date]];
    }
    return self;
}

-(void)didMoveToWindow{
    
}

+ (DKPageScrollView*)pageScrollViewWithNumberOfCells:(int)number frame:(CGRect)frame cellSize:(CGSize)size{
    DKPageScrollView * view = [[DKPageScrollView alloc]initWithFrame:frame];
    for (int i= 0;i<number;i++) {
        DKPageScrollViewCell * cell = [[DKPageScrollViewCell alloc]initWithFrame:CGRectMake(5+ i*size.width, 0,size.width, size.height)];
        cell.index = i;
        view.scrollView.contentSize = CGSizeMake(view.scrollView.contentSize.width+ cell.frame.size.width, view.scrollView.contentSize.height);
        cell.delegate = view;
        [view.scrollView addSubview:cell];
        [view.cells addObject:cell];
        int number = view.scrollView.contentSize.width/view.scrollView.frame.size.width;
        view.pageControl.numberOfPages = number;
       
        
    }
    return view;
}

- (void)switchPage{
    temp ++;
    self.pageControl.currentPage ++;
    if (self.pageControl.numberOfPages) {
        self.pageControl.currentPage = temp%self.pageControl.numberOfPages;
    }
    [self.scrollView setContentOffset:CGPointMake(320*self.pageControl.currentPage, 0) animated:YES];
}

- (void)pageScrollViewActionTouched:(DKPageScrollViewCell *)cell index:(int)index{
    [self.delegate pageScrollViewActionTouched:cell index:index];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int number = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = number;
}

- (void)addImagesWithPics:(NSArray*)pic{
    
}

- (void)addImagesWithPicUrls:(NSArray*)urls{
    
}
@end
