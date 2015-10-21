//
//  DHNavigationTransition.m
//  NavigationControllerTransition
//
//  Created by DreamHack on 15-10-20.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHNavigationTransition.h"
#import "DHTransitionAnimation.h"

@interface DHNavigationTransition ()<UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>

/**
 *  在返回animationController的方法里面获取，在实现动画的时候判断是pop还是push
 */
@property (nonatomic, assign) UINavigationControllerOperation operation;

/**
 *  属性持有，防止ARC过度释放
 */
@property (nonatomic, strong) DHTransitionAnimation * transitionAnimation;

/**
 *  默认这个属性是nil，只有在手势开始到手势结束的这段时间（表示可交互的转场）才有一个正常的值
 */
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition * interactiveTransition;

/**
 *  这个类管理的导航控制器
 */
@property (nonatomic, strong) UINavigationController * navigationController;

/**
 *  右滑pop的手势
 */
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer * popGestureRecognizer;

@end

@implementation DHNavigationTransition

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    // 设置代理
    self.navigationController.delegate = self;
    
    UIScreenEdgePanGestureRecognizer * panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    panGesture.edges = UIRectEdgeLeft;
    
    [self.navigationController.view addGestureRecognizer:panGesture];
    self.popGestureRecognizer = panGesture;
    return self;
}

#pragma mark - navigationControllerDelegate

// 在调用interactionController之后调用，这个方法如果返回nil，则说明不需要进行自定义转场动画，NAVC就会走自己默认的转场动画。如果返回一个正确的对象，则NAVC拿到这个对象，用这个对象来调用协议方法进行转场
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.operation = operation;
    return self;
}

// 转场开始的时候就会调用，如果返回nil，说明不需要可交互的转场动画，则NAVC就会让动画无阻塞的走下去。如果返回一个正确的对象，则说明此时是可交互的转场，则NAVC会暂停动画，用这个对象来调用方法控制转场的进程
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

#pragma mark - viewControllerAnimatedTransitioning

// 转场持续时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.65;
}

// 转场动画的实现。用上下文获取containerView、fromView、toView，把from和to加到container上，然后给from和to加动画。要注意的是需要判断这次是pop还是push
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    DHTransitionAnimation * transitionAnimation = [DHTransitionAnimation transitionAnimationWithTransitionContext:transitionContext];
    
    [transitionAnimation prepareForAnimationWithNavigationOperation:self.operation];
    
    self.transitionAnimation = transitionAnimation;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:transitionAnimation.animationBlock completion:transitionAnimation.completionBlock];
    
}

#pragma mark - callback

- (void)onPan:(UIScreenEdgePanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 开始交互式转场
        self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        // 因为上一行已经给属性赋值了，这行pop的代码一调用，NAVC就会用它的代理调用返回interactionController的方法，此时这个方法就会返回正确的对象，则NAVC就会暂停动画
        [self.navigationController popViewControllerAnimated:YES];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint transition = [sender translationInView:sender.view];
        // 计算转场进程百分比。用手指移动的距离/手指一共可移动的距离，我们这里定为300
        CGFloat percent = transition.x / 300.f;
        if (percent < 0) {
            percent = 0;
        }
        
        // 设置转场进程，系统会自动帮我们更新动画进程来更新界面显示
        [self.interactiveTransition updateInteractiveTransition:percent];
    } else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [sender velocityInView:sender.view];
        if (velocity.x > 0) {
            // 转场完成。系统会让转场动画从当前位置继续走完。
            [self.interactiveTransition finishInteractiveTransition];
        } else {
            // 转场取消。系统会让转场动画从当前位置返回最开始的状态。
            [self.interactiveTransition cancelInteractiveTransition];
        }
        // 可交互转场结束后一定要重新设为nil，不然以后调用所有的pop操作NAVC都会认为这是可交互的转场
        self.interactiveTransition = nil;
    }
}

@end
