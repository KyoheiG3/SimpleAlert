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
        let backgroundView = UIView(frame: container.bounds)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.alpha = 0
        backgroundView.backgroundColor = backgroundColor.withAlphaComponent(0.4)
        container.addSubview(backgroundView)

        to.view.frame = container.bounds
        to.view.transform = from.view.transform.concatenating(CGAffineTransform(scaleX: 1.2, y: 1.2))
        to.view.alpha = 0
        container.addSubview(to.view)

        UIView.animate(withDuration: duration, animations: {
            to.view.transform = from.view.transform
            container.subviews.forEach { view in
                view.alpha = 1
            }
        }) { _ in
            completion(true)
        }
    }
}
