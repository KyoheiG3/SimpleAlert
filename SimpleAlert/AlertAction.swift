//
//  AlertAction.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2016/09/12.
//  Copyright © 2016年 kyohei_ito. All rights reserved.
//

open class AlertAction {
    public enum Style {
        case `default`
        case ok
        case cancel
        case destructive
    }
    
    public init(title: String, style: Style, handler: ((AlertAction?) -> Void)? = nil) {
        self.title = title
        self.handler = handler
        self.style = style
    }
    
    public convenience init(title: String, style: Style, dismissesAlert: Bool, handler: ((AlertAction?) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        self.dismissesAlert = dismissesAlert
    }
    
    var title: String
    var handler: ((AlertAction) -> Void)?
    var style: Style
    var dismissesAlert = true
    open var enabled: Bool = true {
        didSet {
            button?.isEnabled = enabled
        }
    }
    open fileprivate(set) var button: UIButton!
    
    func setButton(_ forButton: UIButton) {
        button = forButton
        button.setTitle(title, for: UIControlState())
        button.isEnabled = enabled
    }
}
