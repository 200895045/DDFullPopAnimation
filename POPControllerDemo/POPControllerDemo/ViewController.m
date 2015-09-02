//
//  ViewController.m
//  POPControllerDemo
//
//  Created by 都基鹏 on 15/9/2.
//  Copyright (c) 2015年 都基鹏. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:self.firstAppear animated:animated];
    
}

- (IBAction)push:(id)sender {
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取Main.storyboard中的第2个视图
    ViewController *viewController = [mainStory instantiateViewControllerWithIdentifier:@"ViewController"];
    viewController.firstAppear = !self.firstAppear;
    
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
