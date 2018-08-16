//
//  BottomSheetTransitioninDelegate.swift
//  Bottomsheet
//
//  Created by Globak Maksim on 21.06.2018.
//  Copyright © 2018 Globak Maksim. All rights reserved.
//

import UIKit

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var transition = UIPercentDrivenInteractiveTransition()
    var isInteractive = true
    
    // MARK: - Animation
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetDismissAnimator()
    }
    
    // MARK: - Interactive
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? transition : nil
    }
    
    // MARK: - Presentation
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
