//
//  AlertController.swift
//  SheetAlertExample
//
//  Created by Kyohei Ito on 2015/01/05.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//

import UIKit
import SimpleAlert

class CustomAlertController: AlertController {
    override func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        super.addTextField { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = nil
            textField.layer.borderColor = nil
            textField.layer.borderWidth = 0

            configurationHandler?(textField)
        }
    }

    override func configureActionButton(_ button: UIButton, at style :AlertAction.Style) {
        super.configureActionButton(button, at: style)
        
        switch style {
        case .ok:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(UIColor.gray, for: .normal)
        case .cancel:
            button.backgroundColor = UIColor.darkGray
            button.setTitleColor(UIColor.white, for: .normal)
        case .default:
            button.setTitleColor(UIColor.lightGray, for: .normal)
        default:
            break
        }
    }

    override func configureContentView(_ contentView: AlertContentView) {
        super.configureContentView(contentView)

        contentView.titleLabel.textColor = UIColor.lightGray
        contentView.titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        contentView.messageLabel.textColor = UIColor.lightGray
        contentView.messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.textBackgroundView.layer.cornerRadius = 10.0
        contentView.textBackgroundView.clipsToBounds = true
        contentView.textBackgroundView.backgroundColor = .lightGray
    }
}
