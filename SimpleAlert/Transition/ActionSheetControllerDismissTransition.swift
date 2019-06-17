//
//  ActionSheetControllerDismissTransition.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

class ActionSheetControllerDismissTransition: ViewControllerAnimatedTransition {
    override func animateTransition(_ from: UIViewController, to: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        container.addSubview(from.view)

        UIView.animate(withDuration: duration, animations: {
            from.view.transform = CGAffineTransform(translationX: 0, y: from.view.bounds.height)
            container.subviews.forEach { view in
                if view !== from.view {
                    view.alpha = 0
                }
            }
        }) { _ in
            completion(true)
        }
    }
}
