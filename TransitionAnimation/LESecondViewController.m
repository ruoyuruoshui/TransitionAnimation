//
//  LESecondViewController.m
//  TransitionAnimation
//
//  Created by 陈记权 on 7/12/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LESecondViewController.h"
#import "LEInvertAnimatedTransitioning.h"
#import "LEPercentDrivenInteractiveTransition.h"

@interface LESecondViewController ()

@property (nonatomic, strong)LEPercentDrivenInteractiveTransition *interactiveTransition;

@end

@implementation LESecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    self.interactiveTransition = [LEPercentDrivenInteractiveTransition new];
    [self.interactiveTransition wireToViewController:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.interactiveTransition = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        LEInvertAnimatedTransitioning *animation = [LEInvertAnimatedTransitioning new];
        return animation;
    }else{
        return nil;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.interactiveTransition;
}

-(void)dealloc
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
