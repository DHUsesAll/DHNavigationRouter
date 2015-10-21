//
//  DHTransitionAnimation.m
//  CustomTransition
//
//  Created by DreamHack on 15-5-10.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHTransitionAnimation.h"

@interface DHTransitionAnimation ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, copy) DHTransitionAnimationBlock animationBlock;
@property (nonatomic, copy) DHTransitionCompletionBlock completionBlock;
@property (nonatomic, assign) UINavigationControllerOperation navigationOperation;


// storer
@property (nonatomic, weak) UIViewController * fromVC;
@property (nonatomic, weak) UIViewController * toVC;
@property (nonatomic, weak) UIView * containerView;

@end

@implementation DHTransitionAnimation

- (void)dealloc
{
    self.transitionContext = nil;
}


+ (instancetype)transitionAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    DHTransitionAnimation * transitionAnimation = [[self alloc] init];
    transitionAnimation.transitionContext = transitionContext;
    return transitionAnimation;
}

- (void)prepareForAnimationWithNavigationOperation:(UINavigationControllerOperation)operation
{
    self.navigationOperation = operation;
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    if (operation == UINavigationControllerOperationPush) {
        [self.containerView addSubview:self.fromVC.view];
        [self.containerView addSubview:self.toVC.view];
        self.toVC.view.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
    } else if (operation == UINavigationControllerOperationPop) {
        [self.containerView addSubview:self.toVC.view];
        [self.containerView addSubview:self.fromVC.view];
        self.toVC.view.transform = CGAffineTransformScale(self.toVC.view.transform, 0.8, 0.8);
    }
}

#pragma mark - getter
- (UIViewController *)fromVC
{
    return [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];;
}

- (UIViewController *)toVC
{

    return [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
}

- (UIView *)containerView
{
    return [_transitionContext containerView];
}

- (DHTransitionAnimationBlock)animationBlock
{
    if (!_animationBlock) {
        
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        
        __weak typeof(self) weakSelf = self;
        
        if (self.navigationOperation == UINavigationControllerOperationPush) {
            self.animationBlock = ^(void) {
            
                weakSelf.fromVC.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                weakSelf.fromVC.view.alpha = 0.4;
                weakSelf.toVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
            
            };
        } else if (self.navigationOperation == UINavigationControllerOperationPop) {
            self.animationBlock = ^(void) {
                
                weakSelf.toVC.view.transform = CGAffineTransformMakeScale(1, 1);
                weakSelf.toVC.view.alpha = 1;
                weakSelf.fromVC.view.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
                
            };
        }
        
    }
    
    return _animationBlock;
}

- (DHTransitionCompletionBlock)completionBlock
{
    if (!_completionBlock) {
        __weak typeof(self) weakSelf = self;
        if (self.navigationOperation == UINavigationControllerOperationPush) {
            
            self.completionBlock = ^(BOOL finished) {
                weakSelf.fromVC.view.transform = CGAffineTransformIdentity;
                [weakSelf.transitionContext completeTransition:![weakSelf.transitionContext transitionWasCancelled]];
            };
            
            
        } else if (self.navigationOperation == UINavigationControllerOperationPop) {
            self.completionBlock = ^(BOOL finished) {
                weakSelf.toVC.view.transform = CGAffineTransformIdentity;
                [weakSelf.transitionContext completeTransition:![weakSelf.transitionContext transitionWasCancelled]];
            };
        }
    }
    
    return _completionBlock;
}


@end
