# DHNavigationRouter
自定义导航控制器的转场动画并实现可交互的转场，把两者封装到一起，使用起来异常简单。
![pic1](https://github.com/DHUsesAll/GitImages/blob/master/DHNavigationRouter/1.gif)

#Usage:
            UIWindow * window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            DHNavigationTransition * transition = [[DHNavigationTransition alloc] initWithRootViewController:[ViewController new]];
            
            // 一定要用属性持有一次，否则ARC会释放这个对象，导致navigationController.delegate成为野指针
            self.transition = transition;
            
            window.rootViewController = transition.navigationController;
            

#顺便封装了一个转场动画，在协议里面使用：
            - (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
            {
                DHTransitionAnimation * transitionAnimation = [DHTransitionAnimation transitionAnimationWithTransitionContext:transitionContext];
                
                [transitionAnimation prepareForAnimationWithNavigationOperation:self.operation];
                
                        //用属性持有，不然会由于ARC机制，动画结束后这个对象就已经被释放了，而动画结束后还需要访问这个对象的属性
                self.transitionAnimation = transitionAnimation;
                
                [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:transitionAnimation.animationBlock completion:transitionAnimation.completionBlock];
                
            }
