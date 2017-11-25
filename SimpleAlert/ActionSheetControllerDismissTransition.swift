//
//  ActionSheetControllerDismissTransition.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

class ActionSheetControllerDismissTransition: ActionSheetControllerTransition {
    override func animateTransition(_ from: UIViewController, to: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        container.addSubview(from.view)

        UIView.animate(withDuration: duration, animations: {
            self.bottomSpace().constant = -from.view.bounds.height
            self.topSpace().constant = from.view.bounds.height
            from.view.backgroundColor = from.view.backgroundColor?.withAlphaComponent(0)
            from.view.layoutIfNeeded()
        }, completion: completion)
    }
}
