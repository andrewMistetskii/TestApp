//
//  ErrorPresenter.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/13/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//
import UIKit
import Foundation

public class ErrorPresenter {
    
    // MARK: - Properties
    
    public var presentTimeInterval: NSTimeInterval = 3.0
    private var presentedViews: [UIView] = []
    private let window: UIWindow
    
    // MARK: - Initializers
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public convenience init?(application: UIApplication) {
        guard let keyWindow = application.keyWindow else {
            return nil
        }
        
        self.init(window: keyWindow)
    }
    
    // MARK: - Public Methods
    
    public func dismissAll() {
        let views = presentedViews
        
        presentedViews = []
        window.windowLevel = UIWindowLevelNormal
        
        views.forEach { $0.removeFromSuperview() }
    }
    
    public func present(error: String, animated: Bool) {
        guard let superview = window.rootViewController?.view else { return }
        present(error, onView: superview, animated: animated)
    }
    
    public func present(error: String, inViewController viewController: UIViewController, animated: Bool) {
        guard let superview = viewController.view else { return }
        present(error, onView: superview, animated: animated)
    }
    
    // MARK: - Private Methods
    
    private func present(error: String, onView superview: UIView, animated: Bool) {
        let view = createView(text: error)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(presentTimeInterval * Double(NSEC_PER_SEC)))
        
        presentedViews.append(view)
        window.windowLevel = UIWindowLevelStatusBar
        
        superview.addSubview(view)
        activateViewConstraints(view, superview: superview)
        
        superview.bringSubviewToFront(view)
        
        if animated {
            addViewPresentingAnimation(view)
        }
        
        dispatch_after(time, dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.presentedViews.remove(view)
            strongSelf.window.windowLevel = strongSelf.presentedViews.isEmpty ? UIWindowLevelNormal : UIWindowLevelStatusBar
            
            if animated {
                strongSelf.addViewDismissingAnimation(view) {
                    view.removeFromSuperview()
                }
            } else {
                view.removeFromSuperview()
            }
        }
    }
    
    private func createLabel(text text: String) -> UILabel {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue", size: 12.0)
        label.lineBreakMode = .ByTruncatingTail
        label.numberOfLines = 1
        label.text = text
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private func createView(text text: String) -> UIView {
        let view = UIView(frame: .zero)
        let label = createLabel(text: text)
        
        view.backgroundColor = UIColor.redColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        activateLabelConstrains(label, superView: view)
        
        return view
    }
    
    private func addViewPresentingAnimation(view: UIView) {
        let animation = CABasicAnimation(keyPath: "position.y")
        
        animation.duration = 0.3
        animation.fromValue = -10.0
        animation.removedOnCompletion = true
        animation.toValue = 10.0
        
        view.layer.addAnimation(animation, forKey: "basic")
    }
    
    private func addViewDismissingAnimation(view: UIView, completion: () -> Void) {
        let animation = CABasicAnimation(keyPath: "position.y")
        
        animation.duration = 0.3
        animation.fromValue = 10.0
        animation.removedOnCompletion = true
        animation.toValue = -10.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        view.layer.addAnimation(animation, forKey: "basic")
        CATransaction.commit()
        
        view.center.y -= 20.0
    }
    
    private func activateLabelConstrains(label: UILabel, superView: UIView) {
        let views = [ "label": label, "superview": superView ]
        
        let verticalConstrains = NSLayoutConstraint.constraintsWithVisualFormat("|-[label]-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let horizontalContrains = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: .AlignAllBaseline, metrics: nil, views: views)
        
        NSLayoutConstraint.activateConstraints(horizontalContrains)
        NSLayoutConstraint.activateConstraints(verticalConstrains)
    }
    
    private func activateViewConstraints(view: UIView, superview: UIView) {
        let views = [ "view": view, "superview": superview ]
        
        let verticalConstrains = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: .AlignAllBaseline, metrics: nil, views: views)
        let horizontalContrains = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view(20)]", options: .AlignAllBaseline, metrics: nil, views: views)
        
        NSLayoutConstraint.activateConstraints(horizontalContrains)
        NSLayoutConstraint.activateConstraints(verticalConstrains)
    }
}
