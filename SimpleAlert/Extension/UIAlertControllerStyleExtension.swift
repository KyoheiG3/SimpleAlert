//
//  UIAlertControllerStyleExtension.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/27.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//
import UIKit

extension UIAlertController.Style {
    var fontSize: CGFloat {
        switch self {
        case .alert: return 17
        case .actionSheet: return 21
        @unknown default: return 17
        }
    }

    var buttonHeight: CGFloat {
        switch self {
        case .alert:
            return 48
        case .actionSheet:
            if #available(iOS 9.0, *) {
                return 58
            } else {
                return 44
            }
        @unknown default:
            return 48
        }
    }
}
