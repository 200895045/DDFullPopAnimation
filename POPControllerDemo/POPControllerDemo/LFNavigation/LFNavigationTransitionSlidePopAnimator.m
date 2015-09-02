//
//  LFNavigationTransitionSlidePopAnimator.m
//  QDaily
//
//  Created by Wei Zhang on 6/9/15.
//  Copyright (c) 2015 Wei Zhang. All rights reserved.
//

#import "LFNavigationTransitionSlidePopAnimator.h"

@implementation LFNavigationTransitionSlidePopAnimator

+ (BOOL)supportOperation:(UINavigationControllerOperation)operation {
    if (operation == UINavigationControllerOperationPop) {
        return YES;
    }
    return NO;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController fromView:(UIView *)fromView toView:(UIView *)toView {

    UIView *containerView = [transitionContext containerView];
    
    UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, NO, 0);
    [fromView drawViewHierarchyInRect:fromView.bounds afterScreenUpdates:YES];
    UIImage *fromViewSnapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect toViewFrame = toView.frame;
    CGRect originalToViewFrame = toView.frame;
    toViewFrame.origin.x = - toViewFrame.size.width / 3;
    toView.frame = toViewFrame;
    
    UIView *maskView = [[UIView alloc] initWithFrame:toViewFrame];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
    
    UIImageView *snapShotView = [[UIImageView alloc] initWithImage:fromViewSnapImage];
    snapShotView.contentMode = UIViewContentModeScaleAspectFill;
    snapShotView.frame = fromView.frame;

    fromView.layer.masksToBounds = NO;
    fromView.layer.shadowOffset = CGSizeMake(-3, 0);
    fromView.layer.shadowRadius = 5;
    fromView.layer.shadowOpacity = 0.2;
    fromView.layer.shadowPath = [UIBezierPath bezierPathWithRect:fromView.bounds].CGPath;
    
    [containerView insertSubview:snapShotView aboveSubview:fromView];
    [containerView insertSubview:toView belowSubview:fromView];
    [containerView insertSubview:maskView aboveSubview:toView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect fromViewFrame = fromView.frame;
        fromViewFrame.origin.x = toView.frame.size.width;
        fromView.frame = fromViewFrame;
        snapShotView.frame = fromViewFrame;

        toView.frame = originalToViewFrame;
        maskView.frame = originalToViewFrame;
        maskView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [maskView removeFromSuperview];
        
        [UIView animateWithDuration:0.15f animations:^{
            snapShotView.alpha = 0;
        } completion:^(BOOL finished) {
            [snapShotView removeFromSuperview];
        }];
        
        if ([transitionContext transitionWasCancelled]) {
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            fromView.frame = CGRectMake(0, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        } else {
            [fromView removeFromSuperview];
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
        }
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
    }];
    
}

@end
