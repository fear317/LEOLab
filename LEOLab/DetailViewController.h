//
//  DetailViewController.h
//  LEOLab
//
//  Created by zhangliaoyuan on 2018/6/7.
//  Copyright © 2018年 zhangliaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

