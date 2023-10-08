//
//  UINavigationController.swift
//  UIKit Navigation
//
//  Created by Raees Rajwani on 07/10/2023.
//

import Foundation
import SwiftUI
import UIKit
import os

//
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBarsOnSwipe = false
        setupFullWidthBackGesture()
    }
    
    // MARK: Back gestures
    private func setupFullWidthBackGesture() {
        // The trick here is to wire up our full-width `fullWidthBackGestureRecognizer` to execute the same handler as
        // the system `interactivePopGestureRecognizer`. That's done by assigning the same "targets" (effectively
        // object and selector) of the system one to our gesture recognizer.
        lazy var fullWidthBackGestureRecognizer = UIPanGestureRecognizer()
        guard
            let interactivePopGestureRecognizer = self.interactivePopGestureRecognizer,
            let targets = interactivePopGestureRecognizer.value(forKey: "targets")
        else {
            return
        }
        
        fullWidthBackGestureRecognizer.setValue(targets, forKey: "targets")
        fullWidthBackGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(fullWidthBackGestureRecognizer)
    }
        
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isSystemSwipeToBackEnabled = interactivePopGestureRecognizer?.isEnabled == true
        let isThereStackedViewControllers = viewControllers.count > 1
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: self.view)
            if translation.x > 0 {
                return isSystemSwipeToBackEnabled && isThereStackedViewControllers
            }
            return false
        }
        return false
    }
}
