//
//  BottomSheetPresentAnimator.swift
//  OTP
//
//  Created by Globak Maksim on 26.06.2018.
//  Copyright © 2018 Globak Maksim. All rights reserved.
//

import UIKit

private let animationDuration = 0.3

class BottomSheetPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        toViewController.view.center.y += toViewController.view.frame.height
        
        let animation = {
            fromViewController.view.clipsToBounds = true
            fromViewController.view.layer.cornerRadius = 8
            fromViewController.view.alpha = 0.6
            // 0.93 - оптимальное значеие уменьшение подложки
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
            toViewController.view.center.y -= toViewController.view.frame.height
        }
        
        let completion: (Bool) -> Void = { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: transitionDuration, animations: animation, completion: completion)
    }
}
