//
//  BottomSheetDismissAnimator.swift
//  Bottomsheet
//
//  Created by Globak Maksim on 21.06.2018.
//  Copyright © 2018 Globak Maksim. All rights reserved.
//

import UIKit

private let animationDuration = 0.3

class BottomSheetDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        let animation = {
            // Return back initial state
            toViewController.view.layer.cornerRadius = 0
            toViewController.view.alpha = 1
            toViewController.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            // Move down BottomSheet
            fromViewController.view.center.y += fromViewController.view.frame.height
        }
        
        let completion: (Bool) -> Void = { _ in
            let isCompleted = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(isCompleted)
            // Radar: http://openradar.appspot.com/radar?id=5320103646199808
            if isCompleted {
                UIApplication.shared.keyWindow?.addSubview(toViewController.view)
            }
        }
        
        UIView.animate(withDuration: transitionDuration, animations: animation, completion: completion)
    }
}
