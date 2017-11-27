//
//  AlertControllerPresentTransition.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

class AlertControllerPresentTransition: ViewControllerAnimatedTransition {
    override func animateTransition(_ from: UIViewController, to: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        to.view.frame = container.bounds
        to.view.backgroundColor = backgroundColor.withAlphaComponent(0.4)
        to.view.transform = from.view.transform.concatenating(CGAffineTransform(scaleX: 1.2, y: 1.2))
        to.view.alpha = 0
        container.addSubview(to.view)

        UIView.animate(withDuration: duration, animations: {
            to.view.transform = from.view.transform
            to.view.alpha = 1
        }, completion: completion)
    }
}
