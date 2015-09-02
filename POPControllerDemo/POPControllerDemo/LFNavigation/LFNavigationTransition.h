//
//  LFNavigationTransition.h
//  QDaily
//
//  Created by Wei Zhang on 6/9/15.
//  Copyright (c) 2015 Wei Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LFNavigationTransition : NSObject

@property (nonatomic, assign) Class animatorClass;
@property (nonatomic, assign) NSTimeInterval transitionDuration;

- (instancetype)initWithViewNavigationController:(UINavigationController *)navigationController;

@end
