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
    
    
    @IBAction func alertButtonWasTapped(sender: AnyObject) {
        let alert = AlertController(title: "title", message: "message", style: .Alert)
        
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
        
        self.presentViewController(alert, animated: true) {
        }
    }
}

