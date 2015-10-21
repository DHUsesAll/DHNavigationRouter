//
//  DHNavigationTransition.h
//  NavigationControllerTransition
//
//  Created by DreamHack on 15-10-20.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DHNavigationTransition : NSObject 

@property (nonatomic, strong, readonly) UINavigationController * navigationController;
/**
 *  留到接口中以提供给外部解决可能出现的手势冲突
 */
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer * popGestureRecognizer;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;



@end
