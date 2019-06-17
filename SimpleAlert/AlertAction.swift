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

        func font(of style: UIAlertController.Style) -> UIFont {
            switch self {
            case .cancel:
                return .boldSystemFont(ofSize: style.fontSize)
            default:
                return .systemFont(ofSize: style.fontSize)
            }
        }
    }

    public init(title: String, style: Style, shouldDismisses: Bool = true, handler: ((AlertAction?) -> Void)? = nil) {
        self.title = title
        self.handler = handler
        self.style = style
        self.shouldDismisses = shouldDismisses

        button.setTitle(title, for: .normal)
        button.setBackgroundImage(UIImage(color: .lightGray), for: .highlighted)
    }

    let title: String
    let handler: ((AlertAction) -> Void)?
    let style: Style
    let shouldDismisses: Bool
    public var button = UIButton(type: .system)
    public var isEnabled: Bool  {
        get { return button.isEnabled }
        set { button.isEnabled = newValue }
    }
}
