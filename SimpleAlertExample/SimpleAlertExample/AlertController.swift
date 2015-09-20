//
//  AlertController.swift
//  SheetAlertExample
//
//  Created by Kyohei Ito on 2015/01/05.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//

import UIKit
import SimpleAlert

class AlertController: SimpleAlert.Controller {
    override func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)? = nil) {
        super.addTextFieldWithConfigurationHandler() { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = nil
            textField.layer.borderColor = nil
            textField.layer.borderWidth = 0
            
            configurationHandler?(textField)
        }
    }
    
    override func configurButton(style :SimpleAlert.Action.Style, forButton button: UIButton) {
        super.configurButton(style, forButton: button)
        
        switch style {
        case .OK:
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        case .Cancel:
            button.backgroundColor = UIColor.darkGrayColor()
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        case .Default:
            button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configContentView = { view in
            if let view = view as? SimpleAlert.ContentView {
                view.titleLabel.textColor = UIColor.lightGrayColor()
                view.titleLabel.font = UIFont.boldSystemFontOfSize(30)
                view.messageLabel.textColor = UIColor.lightGrayColor()
                view.messageLabel.font = UIFont.boldSystemFontOfSize(16)
                view.textBackgroundView.layer.cornerRadius = 3.0
                view.textBackgroundView.clipsToBounds = true
            }
        }
    }
}
