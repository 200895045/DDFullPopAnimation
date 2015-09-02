//
//  NavViewController.m
//  POPControllerDemo
//
//  Created by 都基鹏 on 15/9/2.
//  Copyright (c) 2015年 都基鹏. All rights reserved.
//

#import "NavViewController.h"
#import <objc/runtime.h>
#import "LFNavigationTransition.h"
#import "LFNavigationTransitionSlidePopAnimator.h"

@interface NavViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) LFNavigationTransition *navigationTransition;
@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //此处为避免私有api审查
    NSString * selectorStringBegin = @"handleNavigation";
    NSString * selectorStringEnd = @"Transition:";
    NSString * selectorString= [NSString stringWithFormat:@"%@%@",selectorStringBegin,selectorStringEnd];
    
    BOOL realizePopAniamtionMetod = [self.interactivePopGestureRecognizer.delegate respondsToSelector:NSSelectorFromString(selectorString)];
    if (realizePopAniamtionMetod) {
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:NSSelectorFromString(@"handleNavigationTransition:")];
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.view addGestureRecognizer:panGestureRecognizer];
        panGestureRecognizer.delegate = self;
    }else{
        self.navigationTransition = [[LFNavigationTransition alloc] initWithViewNavigationController:self];
        self.navigationTransition.transitionDuration = 0.25f;
        self.navigationTransition.animatorClass = [LFNavigationTransitionSlidePopAnimator class];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.childViewControllers.count > 1) {
        return YES;
    }
    return NO;
}

@end
