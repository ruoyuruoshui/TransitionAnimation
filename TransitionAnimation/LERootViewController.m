//
//  LERootViewController.m
//  TransitionAnimation
//
//  Created by 陈记权 on 7/12/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LERootViewController.h"
#import "LEAnimatedTransitioning.h"

@interface LERootViewController ()


@end

@implementation LERootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        LEAnimatedTransitioning *animation = [LEAnimatedTransitioning new];
        return animation;
    }else{
        return nil;
    }
}

@end
