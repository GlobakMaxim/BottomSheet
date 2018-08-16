//
//  BottomSheetPresentationController.swift
//  Bottomsheet
//
//  Created by Globak Maksim on 22.06.2018.
//  Copyright © 2018 Globak Maksim. All rights reserved.
//

import UIKit

let topPadding: CGFloat = 32

class BottomSheetPresentationController: UIPresentationController {
    
    // TODO: - Fix layout when view was rotated
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerFrame = containerView?.frame else { return .zero }
        return CGRect(x: 0, y: topPadding, width: containerFrame.width, height: containerFrame.height - topPadding)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
