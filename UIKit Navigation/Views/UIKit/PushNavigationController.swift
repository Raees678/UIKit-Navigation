//
//  PushNavigationController.swift
//  UIKit Navigation
//
//  Created by Raees Rajwani on 08/10/2023.
//

import Foundation
import UIKit

class PushNavigationController: UINavigationController {
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var edgeSwipeGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    private var lastViewControllersState: [UIViewController] = []
    private var lastPoppedViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer!.edges = .right
        view.addGestureRecognizer(edgeSwipeGestureRecognizer!)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // if we are popping a view controller
        if self.viewControllers.count < lastViewControllersState.count {
            // then append the lastViewController.state's last element
            // FORCE UNWRAP SAFETY: by virtue of us popping a viewController we know the lastViewControllerState had at least 1 element to pop
            lastPoppedViewControllers.append(lastViewControllersState.last!)
        } else {
            // if we are pushing a viewController
            // if the viewController we are pushing is the one we had last popped
            // simply pretend like we never popped it and remove it from the lastPoppedViewControllers list
            if viewController == lastPoppedViewControllers.last {
                lastPoppedViewControllers.removeLast()
            } else {
                // the viewController we are pushing is in a different heirachy from the lastPoppedViewControllers list
                // so remove all the lastPoppedViewControllers
                lastPoppedViewControllers.removeAll()
            }
        }
        lastViewControllersState = self.viewControllers
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let percent = abs(gestureRecognizer.translation(in: gestureRecognizer.view!).x / gestureRecognizer.view!.bounds.size.width)
        let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view!)
        guard let lastPoppedViewController = lastPoppedViewControllers.last else {
            return
        }

        switch gestureRecognizer.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            pushViewController(lastPoppedViewController, animated: true)
        case .changed:
            interactionController?.update(percent)
        case .ended, .cancelled:
            if percent > 0.05 && velocity.x < 0 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            break
        }
    }


}

extension PushNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return TransitionAnimator(presenting: true)
        case .pop:
            return nil
        default:
            return nil
        }
    }

    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }

}

final class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationController.hideShowBarDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let duration = transitionDuration(using: transitionContext)
        let container = transitionContext.containerView

        let fullScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let partialScreenLeft = CGAffineTransform(translationX: -container.frame.width * 0.2, y: 0)

        if presenting {
            container.addSubview(toView)
            toView.transform = fullScreenRight
            
            applyShadow(to: toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
            // No initial transform applied to fromView. It'll start from its original position.
            applyShadow(to: fromView)

        }

        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            if self.presenting {
                fromView.transform = partialScreenLeft
                toView.transform = .identity
            } else {
                fromView.transform = fullScreenRight
                toView.transform = partialScreenLeft
            }
        }, completion: { finished in
            fromView.transform = .identity
            toView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

private func applyShadow(to view: UIView) {
    view.layer.shadowOpacity = 0.3
    view.layer.shadowRadius = 12
    view.layer.masksToBounds = false
}

