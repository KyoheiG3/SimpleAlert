//
//  ActionSheetControllerPresentTransition.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

class ActionSheetControllerPresentTransition: ViewControllerAnimatedTransition {
    override func animateTransition(_ from: UIViewController, to: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        let backgroundView = UIView(frame: container.bounds)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.alpha = 0
        backgroundView.backgroundColor = backgroundColor.withAlphaComponent(0.4)
        container.addSubview(backgroundView)

        to.view.frame = container.bounds
        container.addSubview(to.view)

        to.view.transform = CGAffineTransform(translationX: 0, y: to.view.bounds.height)

        UIView.animate(withDuration: duration, animations: {
            to.view.transform = .identity
            backgroundView.alpha = 1
        }) { _ in
            completion(true)
        }
    }
}
