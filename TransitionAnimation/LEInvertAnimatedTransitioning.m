//
//  LEAnimatedTransitioning.m
//  TransitionAnimation
//
//  Created by 陈记权 on 7/12/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LEInvertAnimatedTransitioning.h"
#import "LERootViewController.h"

@interface LEInvertAnimatedTransitioning ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation LEInvertAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    
    UIBarButtonItem *barButtonItem = toVC.navigationItem.rightBarButtonItem;
    UIButton *button = barButtonItem.customView;
    
    CGRect frameInNaviView = [toVC.navigationController.view convertRect:button.frame fromView:toVC.navigationController.view];
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:frameInNaviView];
    
    CGPoint startPoint;
    
    if(button.frame.origin.x > (toVC.view.bounds.size.width / 2)){
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            startPoint = CGPointMake(button.center.x, button.center.y - CGRectGetMaxY(toVC.view.bounds) + 30);
        }else{
            //第四象限
            startPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else{
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            startPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds),
                                     button.center.y - CGRectGetMaxY(toVC.view.bounds) + 30);
        }else{
            //第三象限
            startPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }
    
    CGFloat radius = sqrt(startPoint.x * startPoint.x + startPoint.y * startPoint.y);
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)startPath.CGPath;
    animation.toValue = (__bridge id)finalPath.CGPath;
    
    animation.duration = [self transitionDuration:transitionContext];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animation.delegate = self;
    [maskLayer addAnimation:animation forKey:@"animation.path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
