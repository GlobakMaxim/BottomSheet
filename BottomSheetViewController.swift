//
//  BottomSheetViewController.swift
//  Bottomsheet
//
//  Created by Globak Maksim on 21.06.2018.
//  Copyright © 2018 Globak Maksim. All rights reserved.
//

import UIKit

protocol BottomSheetDataSource: class {
    
    func viewController(for bottomSheet: BottomSheetViewController) -> UIViewController
    
}

class BottomSheetViewController: UIViewController {
    
    // MARK: - Public
    
    var dataSource: BottomSheetDataSource?
    
    // MARK: - Private variables
    
    private var bottomSheetTransitioninDelegate = BottomSheetTransitioningDelegate()
    
    private var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private lazy var dragArea: UIView = {
       let dragView = UIView()
        dragView.backgroundColor = .lightGray
        dragView.layer.cornerRadius = 2;
        
        return dragView
    }()
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        transitioningDelegate = bottomSheetTransitioninDelegate
        modalPresentationStyle = .custom
    }
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presentDataSource()
        roundTopCorners(for: view)
        setupDragArea()
        setupPanGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modalPresentationCapturesStatusBarAppearance = true
        statusBarStyle = .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        statusBarStyle = .default
        modalPresentationCapturesStatusBarAppearance = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    // MARK: - Helper functions
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        bottomSheetTransitioninDelegate.isInteractive = true
        super.dismiss(animated: flag, completion: completion)
    }
    
    private func presentDataSource() {
        guard let dataSource = dataSource?.viewController(for: self) else { return }
        addChildViewController(dataSource)
        view.addSubview(dataSource.view)
        dataSource.didMove(toParentViewController: self)
    }
    
    private func setupPanGestureRecognizer() {
        let gestureRecignizer = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gestureRecignizer)
    }
    
    private func setupDragArea() {
        view.addSubview(dragArea)
        
        dragArea.translatesAutoresizingMaskIntoConstraints = false
        dragArea.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        dragArea.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dragArea.heightAnchor.constraint(equalToConstant: 4).isActive = true
        dragArea.widthAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    private func roundTopCorners(for view: UIView) {
        // TODO: - Move to view extension
        let cornerRadius: CGFloat = 16
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        let bottomSheetPath = UIBezierPath(roundedRect:view.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: cornerRadii)
        let bottomSheetMaskLayer = CAShapeLayer()
        
        bottomSheetMaskLayer.path = bottomSheetPath.cgPath
        view.layer.mask = bottomSheetMaskLayer
    }
    
    // MARK: - Actions
    
    @objc private func handleGesture(_ sender: UIPanGestureRecognizer) {
        let transition = bottomSheetTransitioninDelegate.transition
        
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let progress = min(max(verticalMovement, 0.0), 1.0)
        let shouldClose = progress > 0.3
        
        switch sender.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            transition.update(progress)
        case .cancelled:
            transition.cancel()
        case .ended:
            shouldClose
                ? transition.finish()
                : transition.cancel()
        default:
            break
        }
    }

}
