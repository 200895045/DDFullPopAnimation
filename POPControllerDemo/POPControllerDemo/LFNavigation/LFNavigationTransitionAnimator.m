//
//  LFNavigationTransitionAnimator.m
//  QDaily
//
//  Created by Wei Zhang on 6/9/15.
//  Copyright (c) 2015 Wei Zhang. All rights reserved.
//

#import "LFNavigationTransitionAnimator.h"

@implementation LFNavigationTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [self animateTransition:transitionContext fromViewController:fromVC toViewController:toVC fromView:fromView toView:toView];
}

+ (BOOL)supportOperation:(UINavigationControllerOperation)operation {
    NSAssert(![self isMemberOfClass:[LFNavigationTransitionAnimator class]], @"LFNavigationTransitionAnimator is an abstract class, you should implement your own supportOperation: method.");
    return NO;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController fromView:(UIView *)fromView toView:(UIView *)toView {
    NSAssert(![self isMemberOfClass:[LFNavigationTransitionAnimator class]], @"LFNavigationTransitionAnimator is an abstract class, you should implement your own animateTransition: method.");
}

@end
