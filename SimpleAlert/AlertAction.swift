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

    public init(title: String, style: Style, dismissesAlert: Bool = true, handler: ((AlertAction?) -> Void)? = nil) {
        self.title = title
        self.handler = handler
        self.style = style
        self.dismissesAlert = dismissesAlert

        button.setTitle(title, for: .normal)
        button.autoresizingMask = .flexibleWidth
        addHorizontalBorder()
    }

    func addHorizontalBorder() {
        let borderView = UIView(frame: CGRect(x: 0, y: -CGFloat.thinWidth, width: button.bounds.width, height: CGFloat.thinWidth))
        borderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        borderView.autoresizingMask = .flexibleWidth
        button.addSubview(borderView)
    }

    func addVerticalBorder() {
        let borderView = UIView(frame: CGRect(x: -CGFloat.thinWidth, y: 0, width: CGFloat.thinWidth, height: button.bounds.height))
        borderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        borderView.autoresizingMask = .flexibleHeight
        button.addSubview(borderView)
    }

    let title: String
    let handler: ((AlertAction) -> Void)?
    let style: Style
    let dismissesAlert: Bool
    public let button = UIButton(type: .system)
    public var isEnabled: Bool  {
        get { return button.isEnabled }
        set { button.isEnabled = newValue }
    }
}

extension UIView {
    func addAction(_ action: AlertAction) {
        addSubview(action.button)
    }
}
