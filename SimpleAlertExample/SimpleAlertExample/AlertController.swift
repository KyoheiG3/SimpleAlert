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
    override func addTextFieldWithConfigurationHandler(_ configurationHandler: ((UITextField?) -> Void)? = nil) {
        super.addTextFieldWithConfigurationHandler() { textField in
            textField?.frame.size.height = 33
            textField?.backgroundColor = nil
            textField?.layer.borderColor = nil
            textField?.layer.borderWidth = 0
            
            configurationHandler?(textField)
        }
    }
    
    override func configurButton(_ style :AlertAction.Style, forButton button: UIButton) {
        super.configurButton(style, forButton: button)
        
        switch style {
        case .ok:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(UIColor.gray, for: UIControlState())
        case .cancel:
            button.backgroundColor = UIColor.darkGray
            button.setTitleColor(UIColor.white, for: UIControlState())
        case .default:
            button.setTitleColor(UIColor.lightGray, for: UIControlState())
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configContentView = { view in
            if let view = view as? AlertContentView {
                view.titleLabel.textColor = UIColor.lightGray
                view.titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
                view.messageLabel.textColor = UIColor.lightGray
                view.messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
                view.textBackgroundView.layer.cornerRadius = 3.0
                view.textBackgroundView.clipsToBounds = true
            }
        }
    }
}
