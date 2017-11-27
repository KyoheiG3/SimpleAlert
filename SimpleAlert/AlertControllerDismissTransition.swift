//
//  AlertControllerDismissTransition.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

class AlertControllerDismissTransition: ViewControllerAnimatedTransition {
    override func animateTransition(_ from: UIViewController, to: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        container.addSubview(from.view)

        UIView.animate(withDuration: duration, animations: {
            from.view.alpha = 0
        }, completion: completion)
    }
}
