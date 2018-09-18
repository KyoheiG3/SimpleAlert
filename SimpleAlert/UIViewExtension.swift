//
//  UIViewExtension.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

extension UIView {
    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        let curve = UIView.AnimationOptions(rawValue: 7 << 16)
        UIView.animate(withDuration: duration, delay: 0, options: curve, animations: animations, completion: completion)
    }
}
