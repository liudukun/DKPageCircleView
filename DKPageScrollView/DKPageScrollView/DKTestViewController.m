//
//  DKTestViewController.m
//  DKPageScrollView
//
//  Created by imac_ldk on 14-9-16.
//  Copyright (c) 2014年 ldk. All rights reserved.
//

#import "DKTestViewController.h"
#import "DKPageScrollView.h"

@interface DKTestViewController ()<DKPageScrollViewDelegate>

@end

@implementation DKTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DKPageScrollView * view = [DKPageScrollView pageScrollViewWithNumberOfCells:10 frame:CGRectMake(0, 0, 320, 320) cellSize:CGSizeMake(100, 320)];
    view.delegate = self;
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pageScrollViewActionTouched:(DKPageScrollViewCell *)cell index:(int)index{
    
}

@end
