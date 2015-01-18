//
//  ViewController.swift
//  SimpleAlertExample
//
//  Created by Kyohei Ito on 2015/01/09.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//

import UIKit
import SimpleAlert

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultAlertButtonWasTapped(sender: AnyObject) {
        let alert = SimpleAlert.Controller(title: "title", message: "message", style: .Alert)
        showAlert(alert)
    }
    
    @IBAction func customAlertButtonWasTapped(sender: AnyObject) {
        let alert = AlertController(title: "title", message: "message", style: .Alert)
        showAlert(alert)
    }
    
    @IBAction func defaultActionSheetButtonWasTapped(sender: AnyObject) {
        let alert = SimpleAlert.Controller(title: "title", message: "message", style: .ActionSheet)
        showAlert(alert)
    }
    
    @IBAction func customActionSheetButtonWasTapped(sender: AnyObject) {
        let alert = AlertController(title: "title", message: "message", style: .ActionSheet)
        showAlert(alert)
    }
    
    @IBAction func customContentButtonWasTapped(sender: AnyObject) {
        let viewController = ContentViewController()
        let alert = SimpleAlert.Controller(view: viewController.view, style: .ActionSheet)
        showAlert(alert)
    }
    
    @IBAction func roundedButtonWasTapped(sender: AnyObject) {
        let alert = SimpleAlert.Controller(view: UIView(), style: .Alert)
        let action = SimpleAlert.Action(title: "?", style: .Cancel) { action in
        }
        
        alert.addAction(action)
        action.button.frame.size.height = 144
        action.button.titleLabel?.font = UIFont.boldSystemFontOfSize(96)
        action.button.setTitleColor(UIColor.redColor(), forState: .Normal)

        alert.configContainerWidth = {
            return 144
        }
        alert.configContainerCornerRadius = {
            return 72
        }
        alert.configContentView = { view in
            view.backgroundColor = UIColor.whiteColor()
        }

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlert(alert: SimpleAlert.Controller) {
        alert.addTextFieldWithConfigurationHandler() { textField in
        }
        
        alert.addTextFieldWithConfigurationHandler() { textField in
        }
        
        alert.addAction(SimpleAlert.Action(title: "Cancel", style: .Cancel) { action in
            })
        
        alert.addAction(SimpleAlert.Action(title: "Default", style: .Default) { action in
            })
        
        alert.addAction(SimpleAlert.Action(title: "Destructive", style: .Destructive) { action in
            })
        
        alert.addAction(SimpleAlert.Action(title: "OK", style: .OK) { action in
            })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func normalAlertButtonWasTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler() { textField in
        }
        
        alert.addTextFieldWithConfigurationHandler() { textField in
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
            })
        
        alert.addAction(UIAlertAction(title: "Default", style: .Default) { action in
            })
        
        alert.addAction(UIAlertAction(title: "Destructive", style: .Destructive) { action in
            })
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { action in
            })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

