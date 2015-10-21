//
//  DHTransitionAnimation.h
//  CustomTransition
//
//  Created by DreamHack on 15-5-10.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DHTransitionAnimationBlock)(void);
typedef void(^DHTransitionCompletionBlock)(BOOL finished);

// 模仿iOS9多任务切换效果的转场动画，在aniamteTransition协议方法的实现里面使用
@interface DHTransitionAnimation : NSObject

+ (instancetype)transitionAnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

- (void)prepareForAnimationWithNavigationOperation:(UINavigationControllerOperation)operation;


@property (nonatomic, copy, readonly) DHTransitionAnimationBlock animationBlock;
@property (nonatomic, copy, readonly) DHTransitionCompletionBlock completionBlock;

@end
