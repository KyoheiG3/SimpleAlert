//
//  AlertController.swift
//  SheetAlertExample
//
//  Created by Kyohei Ito on 2015/01/05.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//

import UIKit
import SimpleAlert

class AlertController: Controller {
    override func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)? = nil) {
        super.addTextFieldWithConfigurationHandler() { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = nil
            textField.layer.borderColor = nil
            textField.layer.borderWidth = 0
            
            configurationHandler?(textField)
        }
    }
    
    override func configurButton(style :AlertAction.Style, forButton button: UIButton) {
        super.configurButton(style, forButton: button)
        
        if let font = button.titleLabel?.font {
            switch style {
            case .Destructive:
                button.backgroundColor = UIColor.lightGrayColor()
                button.titleLabel?.font = UIFont.systemFontOfSize(font.pointSize)
            case .OK:
                button.titleLabel?.font = UIFont.systemFontOfSize(font.pointSize)
            case .Cancel:
                button.titleLabel?.font = UIFont.boldSystemFontOfSize(font.pointSize)
            case .Default:
                button.titleLabel?.font = UIFont.systemFontOfSize(font.pointSize)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configContentView = { [weak self] view in
            if let view = view as? ContentView {
                view.titleLabel.textColor = UIColor.lightGrayColor()
                view.messageLabel.textColor = UIColor.lightGrayColor()
                view.textBackgroundView.layer.cornerRadius = 3.0
                view.textBackgroundView.clipsToBounds = true
            }
        }
    }
}
