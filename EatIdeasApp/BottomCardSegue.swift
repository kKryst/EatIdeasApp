//
//  BottomCardSegue.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 26/02/2023.
//

import UIKit

class BottomCardSegue: UIStoryboardSegue {
private var selfRetainer: BottomCardSegue? = nil
override func perform() {
        destination.transitioningDelegate = self
        selfRetainer = self
        destination.modalPresentationStyle = .overCurrentContext
        source.present(destination, animated: true, completion: nil)
    }
}
extension BottomCardSegue: UIViewControllerTransitioningDelegate {
public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
return TransitioningAnimatorIn()
    }
public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        selfRetainer = nil
return TransitioningAnimatorOut()
    }
}
class TransitioningAnimatorIn: NSObject, UIViewControllerAnimatedTransitioning {
func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
return 0.5
    }
func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
guard
let toViewController = transitionContext.viewController(forKey: .to)
else {
return
        }
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
class TransitioningAnimatorOut: NSObject, UIViewControllerAnimatedTransitioning {
func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
return 0.5
    }
func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
guard
let fromViewController = transitionContext.viewController(forKey: .from)
else {
return
        }
let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

