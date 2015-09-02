//
//  LFNavigationTransition.m
//  QDaily
//
//  Created by Wei Zhang on 6/9/15.
//  Copyright (c) 2015 Wei Zhang. All rights reserved.
//

#import "LFNavigationTransition.h"
#import "LFNavigationTransitionAnimator.h"

@interface LFNavigationTransition () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic, assign) BOOL shouldCompleteTransition;
@property (nonatomic, assign) BOOL interactionInProgress;
@property (nonatomic, strong) UIPanGestureRecognizer *swipeBackGestureRecognizer;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgeSwipeBackGestureRecognizer;

@end

@implementation LFNavigationTransition

#pragma mark -
#pragma mark Accessors

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition {
    if (!_interactivePopTransition) {
        _interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
    }
    return _interactivePopTransition;
}

#pragma mark -
#pragma mark Initialization

- (instancetype)initWithViewNavigationController:(UINavigationController *)navigationController {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _navigationController = navigationController;
    _navigationController.delegate = self;
    _navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIPanGestureRecognizer *swipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeRecognizer.maximumNumberOfTouches = 1;
    swipeRecognizer.delegate = self;
    _swipeBackGestureRecognizer = swipeRecognizer;
    
    UIScreenEdgePanGestureRecognizer *edgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    edgePanRecognizer.edges = UIRectEdgeLeft;
    edgePanRecognizer.delegate = self;
    _edgeSwipeBackGestureRecognizer = edgePanRecognizer;
    
    [_navigationController.interactivePopGestureRecognizer.view addGestureRecognizer:swipeRecognizer];
    [_navigationController.interactivePopGestureRecognizer.view addGestureRecognizer:edgePanRecognizer];
    
    return self;
}

- (void)handleSwipeGesture:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactionInProgress = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.interactionInProgress) {
                
                CGFloat percent = [recognizer translationInView:recognizer.view].x / recognizer.view.bounds.size.width;
                percent = fminf(fmaxf(percent, 0.0), 1.0);
                
                // if an interactive transitions is 100% completed via the user interaction, for some reason
                // the animation completion block is not called, and hence the transition is not completed.
                // This glorious hack makes sure that this doesn't happen.
                if (percent >= 1.0) percent = 0.99;
                
                self.shouldCompleteTransition = (percent > 0.25);
                [self.interactivePopTransition updateInteractiveTransition:percent];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.interactionInProgress) {
                self.interactionInProgress = NO;
                if (!self.shouldCompleteTransition || recognizer.state == UIGestureRecognizerStateCancelled) {
                    [self.interactivePopTransition cancelInteractiveTransition];
                } else {
                    [self.interactivePopTransition finishInteractiveTransition];
                }
                
                self.interactivePopTransition = nil;
            }
        }
            
            break;
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.swipeBackGestureRecognizer || gestureRecognizer == self.edgeSwipeBackGestureRecognizer) {
        if (self.navigationController.viewControllers.count == 1) {
            return NO;
        }
        
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:panGesture.view];
        CGPoint velocity = [panGesture velocityInView:panGesture.view];
        if (velocity.x > 0 && (velocity.x < 600 && ABS(translation.x) / ABS(translation.y) > 1)) {
            return YES;
        }
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark UINavigationViewController Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    
    if (self.animatorClass) {
        
        id<UIViewControllerAnimatedTransitioning> animator = [[self.animatorClass alloc] init];
        
        if ([animator isKindOfClass:[LFNavigationTransitionAnimator class]]) {
            if ([[((LFNavigationTransitionAnimator *)animator) class] supportOperation:operation]) {
                ((LFNavigationTransitionAnimator *)animator).transitionDuration = self.transitionDuration;
                return animator;
            }
        } else if ([animator conformsToProtocol:@protocol(UIViewControllerAnimatedTransitioning)]) {
            return animator;
        }
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([self interactionInProgress] && [animationController isKindOfClass:self.animatorClass]) {
        return self.interactivePopTransition;
    }
    
    return nil;
}

@end
