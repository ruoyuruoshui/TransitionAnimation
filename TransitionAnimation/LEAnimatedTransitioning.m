//
//  LEAnimatedTransitioning.m
//  TransitionAnimation
//
//  Created by 陈记权 on 7/13/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LEAnimatedTransitioning.h"

@interface LEAnimatedTransitioning ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation LEAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contentView = [transitionContext containerView];
    [contentView addSubview:fromVC.view];
    [contentView addSubview:toVC.view];
    
    UIBarButtonItem *rightItem = fromVC.navigationItem.rightBarButtonItem;
    UIButton *button = rightItem.customView;
    
    CGRect frame = [fromVC.navigationController.view convertRect:button.frame toView:fromVC.navigationController.view];
    CGPoint finalPoint = CGPointZero;
    
    if (CGRectGetMinX(button.frame) > CGRectGetWidth(fromVC.view.frame) / 2.0f) {
        if (CGRectGetMinY(button.frame) < CGRectGetHeight(fromVC.view.frame) / 2.0f) {
            finalPoint = CGPointMake(button.center.x, button.center.y - CGRectGetMaxY(fromVC.view.frame) + 30);
        } else {
            finalPoint = CGPointMake(button.center.x, button.center.y);
        }
    } else {
        if (CGRectGetMinY(button.frame) < CGRectGetHeight(fromVC.view.frame) / 2.0f) {
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(fromVC.view.frame), button.center.y - CGRectGetMaxY(fromVC.view.frame));
        } else {
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxY(fromVC.view.frame), button.center.y);
        }
    }
    
    CGFloat radius = sqrt(pow(finalPoint.x, 2) + pow(finalPoint.y, 2));
    
    UIBezierPath *maskFinalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    UIBezierPath *maskBeginPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalPath.CGPath;
    
    /*
     An optional layer whose alpha channel is used to mask the layer’s content.
     The layer’s alpha channel determines how much of the layer’s content and background shows through. 
     Fully or partially opaque pixels allow the underlying content to show through but fully transparent pixels block that content.
     The default value of this property is nil nil. 
     When configuring a mask, remember to set the size and position of the mask layer to ensure it is aligned properly with the layer it masks.
     The layer you assign to this property must not have a superlayer. If it does, the behavior is undefined.
     */
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = [self transitionDuration:self.transitionContext];
    animation.fromValue = (__bridge id)maskBeginPath.CGPath;
    animation.toValue = (__bridge id)maskFinalPath.CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animation.delegate = self;
    [maskLayer addAnimation:animation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
