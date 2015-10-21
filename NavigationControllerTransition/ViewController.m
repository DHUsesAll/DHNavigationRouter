//
//  ViewController.m
//  NavigationControllerTransition
//
//  Created by DreamHack on 15-6-12.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "ViewController.h"
#import "DHNavigationTransition.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat r = arc4random()%256/255.f;
    CGFloat g = arc4random()%256/255.f;
    CGFloat b = arc4random()%256/255.f;
    self.view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    self.title = [NSString stringWithFormat:@"%.2f,%.2f,%.2f",r,g,b];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}


@end
