//
//  LEPercentDrivenInteractiveTransition.m
//  TransitionAnimation
//
//  Created by 陈记权 on 7/13/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LEPercentDrivenInteractiveTransition.h"

@interface LEPercentDrivenInteractiveTransition ()
{
    UIViewController *m_viewController;
}

@end

@implementation LEPercentDrivenInteractiveTransition

- (void)wireToViewController:(UIViewController *)controller
{
    m_viewController = controller;
    
    [self _prepareGestureRecognizerInView:controller.view];
}

- (void)_prepareGestureRecognizerInView:(UIView *)view
{
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self
                                                                                                        action:@selector(edgePanGestureAction:)];
    edgePanGesture.edges = UIRectEdgeLeft;

    [view addGestureRecognizer:edgePanGesture];
}

- (void)edgePanGestureAction:(UIScreenEdgePanGestureRecognizer *)panGesture
{
    CGFloat percent = [panGesture translationInView:m_viewController.view].x / CGRectGetWidth(m_viewController.view.bounds);
    percent = MIN(1.0, MAX(0.0, percent));
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [m_viewController.navigationController popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            if (percent > 0.5) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
