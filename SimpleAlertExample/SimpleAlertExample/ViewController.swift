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
    
    @IBAction func defaultAlertButtonWasTapped(_ sender: AnyObject) {
        let alert = AlertController(title: "title", message: "message", style: .alert)
        showAlert(alert)
    }
    
    @IBAction func customAlertButtonWasTapped(_ sender: AnyObject) {
        let alert = CustomAlertController(title: "title", message: "message", style: .alert)
        showAlert(alert)
    }
    
    @IBAction func defaultActionSheetButtonWasTapped(_ sender: AnyObject) {
        let alert = AlertController(title: "title", message: "message", style: .actionSheet)
        showAlert(alert)
    }
    
    @IBAction func customActionSheetButtonWasTapped(_ sender: AnyObject) {
        let alert = CustomAlertController(title: "title", message: "message", style: .actionSheet)
        showAlert(alert)
    }
    
    @IBAction func customContentButtonWasTapped(_ sender: AnyObject) {
        let viewController = ContentViewController()
        let alert = AlertController(view: viewController.view, style: .actionSheet)
        showAlert(alert)
    }
    
    @IBAction func roundedButtonWasTapped(_ sender: AnyObject) {
        let alert = AlertController(view: UIView(), style: .alert)
        let action = AlertAction(title: "?", style: .cancel) { action in
        }
        
        alert.addAction(action)
        action.button.frame.size.height = 144
        action.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 96)
        action.button.setTitleColor(UIColor.red, for: .normal)

        alert.configContainerWidth = {
            return 144
        }
        alert.configContainerCornerRadius = {
            return 72
        }
        alert.configContentView = { view in
            view?.backgroundColor = UIColor.white
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ alert: AlertController) {
        alert.addTextFieldWithConfigurationHandler() { textField in
        }
        
        alert.addTextFieldWithConfigurationHandler() { textField in
        }
        
        alert.addAction(AlertAction(title: "Cancel", style: .cancel) { action in
            })
        
        alert.addAction(AlertAction(title: "Default", style: .default) { action in
            })
        
        alert.addAction(AlertAction(title: "Destructive", style: .destructive) { action in
            })
        
        alert.addAction(AlertAction(title: "OK", style: .ok) { action in
            })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func normalAlertButtonWasTapped(_ sender: AnyObject) {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        alert.addTextField() { textField in
        }
        
        alert.addTextField() { textField in
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            })
        
        alert.addAction(UIAlertAction(title: "Default", style: .default) { action in
            })
        
        alert.addAction(UIAlertAction(title: "Destructive", style: .destructive) { action in
            })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            })
        
        self.present(alert, animated: true, completion: nil)
    }
}

