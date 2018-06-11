//
//  LEOSegmentControlViewController.h
//  LEOLab
//
//  Created by zhangliaoyuan on 2018/6/7.
//  Copyright © 2018年 zhangliaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAYDSegmentedControllViewDelegate <NSObject>

- (void)viewControllerDidBecomeInvisible:(UIViewController *)viewController isSwiping:(BOOL)isSwiping;
- (void)viewControllerDidBecomeVisible:(UIViewController *)viewController firstAppear:(BOOL)firstAppear isSwiping:(BOOL)isSwiping;
@optional
- (void)viewControllerFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end


@interface LEOSegmentControlViewController : UIViewController <MAYDSegmentedControllViewDelegate>
@property (assign, nonatomic) NSInteger currentPageIndex;
@property (nonatomic, strong) NSArray *viewControllers;
@property (strong, nonatomic) UIScrollView *pageScrollView;
@property (nonatomic, weak) id <MAYDSegmentedControllViewDelegate> pageDelegate; // defaults to self
@property (strong, nonatomic) NSArray *titles;
@end
