//
//  ActionSheetControllerTransition.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

class ActionSheetControllerTransition: ViewControllerAnimatedTransition {
    let topSpace: () -> NSLayoutConstraint
    let bottomSpace: () -> NSLayoutConstraint
    init(backgroundColor: UIColor, topSpace: @autoclosure @escaping () -> NSLayoutConstraint, bottomSpace: @autoclosure @escaping () -> NSLayoutConstraint) {
        self.topSpace = topSpace
        self.bottomSpace = bottomSpace
        super.init(backgroundColor: backgroundColor)
    }
}
