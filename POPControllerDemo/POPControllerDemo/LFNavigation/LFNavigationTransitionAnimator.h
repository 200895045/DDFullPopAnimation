//
//  LFNavigationTransitionAnimator.h
//  QDaily
//
//  Created by Wei Zhang on 6/9/15.
//  Copyright (c) 2015 Wei Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LFNavigationTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) NSTimeInterval transitionDuration;
@property (nonatomic, assign) UINavigationControllerOperation currentOperation;

+ (BOOL)supportOperation:(UINavigationControllerOperation)operation;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController fromView:(UIView *)fromView toView:(UIView *)toView;

@end
