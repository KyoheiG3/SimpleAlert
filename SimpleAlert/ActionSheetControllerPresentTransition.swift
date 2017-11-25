//
//  ActionSheetControllerPresentTransition.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

class ActionSheetControllerPresentTransition: ActionSheetControllerTransition {
    override func animateTransition(_ from: UIViewController, to: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        to.view.frame = container.bounds
        to.view.backgroundColor = backgroundColor.withAlphaComponent(0)
        container.addSubview(to.view)

        topSpace().constant = to.view.bounds.height
        bottomSpace().constant = -to.view.bounds.height
        to.view.layoutIfNeeded()

        UIView.animate(withDuration: duration, animations: {
            self.topSpace().constant = 0
            self.bottomSpace().constant = 0
            to.view.backgroundColor = to.view.backgroundColor?.withAlphaComponent(0.4)
            to.view.layoutIfNeeded()
        }, completion: completion)
    }
}
