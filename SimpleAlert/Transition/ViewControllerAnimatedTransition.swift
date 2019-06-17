//
//  ViewControllerAnimatedTransition.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

class ViewControllerAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let backgroundColor: UIColor
    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        super.init()
    }

    var duration: TimeInterval {
        return 0.3
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return transitionContext.completeTransition(false)
        }

        guard let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return transitionContext.completeTransition(false)
        }

        animateTransition(fromController, to: toController, container: transitionContext.containerView) {
            transitionContext.completeTransition($0)
        }
    }

    func animateTransition(_ from: UIViewController, to: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        container.addSubview(to.view)

        UIView.animate(withDuration: duration, animations: container.layoutIfNeeded, completion: completion)
    }
}
