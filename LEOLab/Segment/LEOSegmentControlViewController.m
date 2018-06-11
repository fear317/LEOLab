//
//  LEOSegmentControlViewController.m
//  LEOLab
//
//  Created by zhangliaoyuan on 2018/6/7.
//  Copyright © 2018年 zhangliaoyuan. All rights reserved.
//

#import "LEOSegmentControlViewController.h"
#import "LEOSegment.h"

@interface LEOSegmentControlViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) LEOSegment *segmentedControl;
@end

@implementation LEOSegmentControlViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageDelegate = self;
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles {
    self = [self init];
    if (self) {
        _titles = titles;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:240 green:240 blue:240 alpha:1.0f]];
    [self.view addSubview:self.pageScrollView];
    [self.navigationItem setTitleView:self.segmentedControl];
    
    CGFloat originX = 0;
    CGFloat pageWidth = self.view.frame.size.width;
    CGFloat pageHeight = self.view.frame.size.height;
    for(UIViewController *vc in self.viewControllers) {
        [vc.view setFrame:CGRectMake(originX, 0, pageWidth, pageHeight)];
        [self.pageScrollView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
        originX += pageWidth;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.pageDelegate conformsToProtocol:@protocol(MAYDSegmentedControllViewDelegate)]) {
        [self.pageDelegate viewControllerDidBecomeVisible:self.viewControllers[self.currentPageIndex] firstAppear:YES isSwiping:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    if ([self.pageDelegate conformsToProtocol:@protocol(MAYDSegmentedControllViewDelegate)] && self.isViewLoaded && self.currentPageIndex < self.viewControllers.count) {
                [self.pageDelegate viewControllerDidBecomeInvisible:self.viewControllers[self.currentPageIndex] isSwiping:YES];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        NSInteger selecIndex = sender.selectedSegmentIndex;
        switch(selecIndex){
            case 0:
//                [self.pageScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                self.pageScrollView.contentOffset = CGPointMake(0, 0);
                sender.selectedSegmentIndex=0;
                self.currentPageIndex = 0;
                break;
            case 1:
//                [self.pageScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
                self.pageScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
                sender.selectedSegmentIndex = 1;
                self.currentPageIndex = 1;
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        if ([self.pageDelegate conformsToProtocol:@protocol(MAYDSegmentedControllViewDelegate)] && self.isViewLoaded && self.currentPageIndex < self.viewControllers.count) {
            [self.pageDelegate viewControllerDidBecomeVisible:self.viewControllers[self.currentPageIndex] firstAppear:NO isSwiping:YES];
        }
    }];
}

#pragma mark - MAYDSegmentedControllViewDelegate
- (void)viewControllerDidBecomeInvisible:(UIViewController *)viewController isSwiping:(BOOL)isSwiping {
    
}
- (void)viewControllerDidBecomeVisible:(UIViewController *)viewController firstAppear:(BOOL)firstAppear isSwiping:(BOOL)isSwiping {
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat rate = (self.view.frame.size.width - offset.x)/self.view.frame.size.width;
    [self.segmentedControl updateIndicateWithOffsetRate:rate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPageIndex = self.currentPageIndex;
    self.currentPageIndex = scrollView.contentOffset.x / self.view.frame.size.width;
    if (currentPageIndex != self.currentPageIndex) {
        [self.segmentedControl setSelectedSegmentIndex:self.currentPageIndex];
        if ([self.pageDelegate conformsToProtocol:@protocol(MAYDSegmentedControllViewDelegate)] && self.isViewLoaded && self.currentPageIndex < self.viewControllers.count) {
            [self.pageDelegate viewControllerDidBecomeVisible:self.viewControllers[self.currentPageIndex] firstAppear:NO isSwiping:NO];
        }
    }
}
#pragma mark - Setter & Getter
- (UIScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _pageScrollView.delegate = self;
        _pageScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);
        [_pageScrollView setPagingEnabled:YES];
        [_pageScrollView setMaximumZoomScale:1.0f];
        [_pageScrollView setMinimumZoomScale:1.0f];
    }
    return _pageScrollView;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    if (self.segmentedControl) {
        NSInteger index = 0;
        for (NSString *title in titles) {
            [self.segmentedControl setTitle:title forSegmentAtIndex:index];
            index++;
        }
    }
}

- (LEOSegment *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[LEOSegment alloc] initWithItems:_titles];
        [_segmentedControl setFrame:CGRectMake(0, 0, 15 * _titles.count + 120, 39)];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl setTintColor:[UIColor clearColor]];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} forState:UIControlStateSelected];
        [_segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}
@end
