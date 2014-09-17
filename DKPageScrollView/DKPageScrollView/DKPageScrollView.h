//
//  DKPageScrollView.h
//  DKPageScrollView
//
//  Created by imac_ldk on 14-9-16.
//  Copyright (c) 2014年 ldk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKPageScrollView : UIScrollView

+ (DKPageScrollView*)createPageScrollViewWithArray:(NSArray*)array frame:(CGRect)frame;

@end
