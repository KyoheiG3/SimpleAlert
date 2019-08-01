//
//  AlertController.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2019/06/13.
//  Copyright © 2019 kyohei_ito. All rights reserved.
//

import UIKit

open class AlertController: UIViewController {
    enum Const {
        static let alertWidth: CGFloat = 270
        static let actionSheetMargin: CGFloat = 16
        static let cornerRadius: CGFloat = 13
        static let textFieldHeight: CGFloat = 25
    }

    @IBOutlet weak var containerView: UIView! {
        didSet {
            if preferredStyle == .actionSheet {
                tapGesture.addTarget(self, action: #selector(AlertController.backgroundViewTapAction(_:)))
                containerView.addGestureRecognizer(tapGesture)
            }
        }
    }

    @IBOutlet weak var containerStackView: UIStackView!

    @IBOutlet weak var contentEffectView: UIVisualEffectView! {
        didSet {
            contentEffectView.clipsToBounds = true
        }
    }

    @IBOutlet weak var cancelEffectView: UIVisualEffectView! {
        didSet {
            cancelEffectView.clipsToBounds = true
            cancelEffectView.isHidden = preferredStyle == .alert
        }
    }

    @IBOutlet weak var contentStackView: UIStackView!

    @IBOutlet weak var contentScrollView: UIScrollView! {
        didSet {
            contentScrollView.showsVerticalScrollIndicator = false
            contentScrollView.showsHorizontalScrollIndicator = false
            if #available(iOS 11.0, *) {
                contentScrollView.contentInsetAdjustmentBehavior = .never
            }
        }
    }

    @IBOutlet weak var alertButtonScrollView: UIScrollView! {
        didSet {
            alertButtonScrollView.showsVerticalScrollIndicator = false
            alertButtonScrollView.showsHorizontalScrollIndicator = false
            if #available(iOS 11.0, *) {
                alertButtonScrollView.contentInsetAdjustmentBehavior = .never
            }
        }
    }

    @IBOutlet weak var cancelButtonScrollView: UIScrollView! {
        didSet {
            alertButtonScrollView.showsVerticalScrollIndicator = false
            alertButtonScrollView.showsHorizontalScrollIndicator = false
            if #available(iOS 11.0, *) {
                cancelButtonScrollView.contentInsetAdjustmentBehavior = .never
            }
        }
    }

    @IBOutlet weak var alertContentView: AlertContentView!
    @IBOutlet weak var alertButtonStackView: UIStackView!
    @IBOutlet weak var cancelButtonStackView: UIStackView!

    @IBOutlet weak var containerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var containerStackViewWidth: NSLayoutConstraint!

    public private(set) var actions: [AlertAction] = []
    public private(set) var textFields: [UITextField] = []

    open var contentWidth: CGFloat?
    open var contentColor: UIColor?
    open var contentCornerRadius: CGFloat?
    open var coverColor: UIColor = .black
    open var message: String?

    private var contentViewHandler: ((AlertContentView) -> Void)?
    private var customView: UIView?
    private var preferredStyle: UIAlertController.Style = .alert
    private let tapGesture = UITapGestureRecognizer()

    private weak var customViewHeightConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
        }
    }

    private weak var containerStackViewYAxisConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private convenience init() {
        let type = AlertController.self
        self.init(nibName: String(describing: type), bundle: Bundle(for: type))
    }

    public convenience init(title: String?, message: String?, style: UIAlertController.Style) {
        self.init()
        self.title = title
        self.message = message
        self.preferredStyle = style
    }

    public convenience init(title: String? = nil, message: String? = nil, view: UIView?, style: UIAlertController.Style) {
        self.init()
        self.title = title
        self.message = message
        customView = view
        preferredStyle = style
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = self
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let color = contentColor {
            contentEffectView.backgroundColor = color
            cancelEffectView.backgroundColor = color
            contentEffectView.effect = nil
            cancelEffectView.effect = nil
        } else {
            contentEffectView.backgroundColor = .white
            cancelEffectView.backgroundColor = .white
        }

        contentEffectView.layer.cornerRadius = contentCornerRadius ?? Const.cornerRadius
        cancelEffectView.layer.cornerRadius = contentCornerRadius ?? Const.cornerRadius

        alertContentView.titleLabel.text = title
        alertContentView.messageLabel.text = message

        if preferredStyle == .alert {
            textFields.forEach { textField in
                alertContentView.append(textField)
                (textField as? TextField)?.handler?(textField)
            }

            textFields.first?.becomeFirstResponder()
        }

        if let view = customView {
            alertContentView.contentStackView.addArrangedSubview(view)
        }

        configureContentView(alertContentView)
        alertContentView.layoutIfNeeded()

        layoutButtons()

        view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(AlertController.keyboardFrameWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlertController.keyboardFrameWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
        alertContentView.endEditing(true)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        alertContentView.removeAllTextField()
        if let view = customView {
            alertContentView.contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        alertButtonStackView.removeAllArrangedSubviews()
        cancelButtonStackView.removeAllArrangedSubviews()
        contentStackView.arrangedSubviews
            .filter { !($0 is UIScrollView) }
            .forEach { view in
                contentStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
        }
    }

    open override func updateViewConstraints() {
        super.updateViewConstraints()

        customViewHeightConstraint?.isActive = false
        containerStackViewYAxisConstraint?.isActive = false

        let minWidth = min(view.bounds.width, view.bounds.height)
        containerStackViewWidth.constant = contentWidth ?? (preferredStyle == .alert ? Const.alertWidth : minWidth - Const.actionSheetMargin)

        let constraint: NSLayoutConstraint
        switch preferredStyle {
        case .alert:
            constraint = containerStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)

        case .actionSheet:
            let bottomAnchor: NSLayoutYAxisAnchor
            if #available(iOS 11.0, *) {
                bottomAnchor = containerView.safeAreaLayoutGuide.bottomAnchor
            } else {
                bottomAnchor = containerView.bottomAnchor
            }
            constraint = containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)

        @unknown default:
            constraint = containerStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        }

        constraint.priority = .defaultHigh
        constraint.isActive = true
        containerStackViewYAxisConstraint = constraint

        if let view = customView {
            let constraint = view.heightAnchor.constraint(equalToConstant: view.bounds.height)
            constraint.isActive = true
            customViewHeightConstraint = constraint
        }
    }

    open func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        let textField = TextField()
        textField.handler = configurationHandler
        textField.heightAnchor.constraint(equalToConstant: Const.textFieldHeight).isActive = true
        textFields.append(textField)
    }

    open func addAction(_ action: AlertAction) {
        action.button.frame.size.height = preferredStyle.buttonHeight
        action.button.addTarget(self, action: #selector(AlertController.buttonDidTap), for: .touchUpInside)

        configureActionButton(action.button, at: action.style)
        actions.append(action)
    }

    open func configureActionButton(_ button: UIButton, at style: AlertAction.Style) {
        if style == .destructive {
            button.setTitleColor(.red, for: .normal)
        }
        button.titleLabel?.font = style.font(of: preferredStyle)
    }

    open func configureContentView(_ contentView: AlertContentView) {
        contentViewHandler?(contentView)
    }

    @discardableResult
    public func configureContentView(configurationHandler: @escaping (AlertContentView) -> Void) -> Self {
        contentViewHandler = configurationHandler
        return self
    }
}

extension AlertController {
    func layoutButtons() {
        alertButtonStackView.axis = preferredStyle == .alert && actions.count == 2 ? .horizontal : .vertical

        switch (preferredStyle, alertButtonStackView.axis) {
        case (.actionSheet, _):
            actions.lazy
                .filter { $0.style != .cancel }
                .forEach(alertButtonStackView.addAction)
            actions.lazy
                .filter { $0.style == .cancel }
                .forEach(cancelButtonStackView.addAction)

            if alertContentView.isHidden, let borderView = alertButtonStackView.arrangedSubviews.first {
                alertButtonStackView.removeArrangedSubview(borderView)
                borderView.removeFromSuperview()
            }

            if let borderView = cancelButtonStackView.arrangedSubviews.first {
                cancelButtonStackView.removeArrangedSubview(borderView)
                borderView.removeFromSuperview()
            }

        case (.alert, .horizontal):
            actions.forEach(alertButtonStackView.addAction)

            if let borderView = alertButtonStackView.arrangedSubviews.first {
                alertButtonStackView.removeArrangedSubview(borderView)
                borderView.removeFromSuperview()
            }

            if !alertContentView.isHidden {
                contentStackView.insertArrangedSubview(contentStackView.makeBorderView(), at: 1)
            }

        case (.alert, .vertical):
            actions.forEach(alertButtonStackView.addAction)

            if alertContentView.isHidden, let borderView = alertButtonStackView.arrangedSubviews.first {
                alertButtonStackView.removeArrangedSubview(borderView)
                borderView.removeFromSuperview()
            }

        @unknown default:
            break
        }

        zip(actions, actions.dropFirst()).forEach { top, bottom in
            top.button.widthAnchor.constraint(equalTo: bottom.button.widthAnchor).isActive = true
        }
    }

    func dismiss(with sender: UIButton) {
        guard let action = actions.filter({ $0.button == sender }).first else {
            dismiss()
            return
        }
        if action.shouldDismisses {
            dismiss {
                action.handler?(action)
            }
        } else {
            action.handler?(action)
        }
    }

    func dismiss(withCompletion block: @escaping () -> Void = {}) {
        dismiss(animated: true) {
            block()
            self.actions.removeAll()
            self.textFields.removeAll()
        }
    }
}

// MARK: - Action Methods
extension AlertController {
    @objc func buttonDidTap(_ button: UIButton) {
        dismiss(with: button)
    }

    @objc func backgroundViewTapAction(_ gesture: UITapGestureRecognizer) {
        if !containerStackView.frame.contains(gesture.location(in: containerView)) {
            dismiss()
        }
    }
}

// MARK: - NSNotificationCenter Methods
extension AlertController {
    @objc func keyboardFrameWillChange(_ notification: Notification) {
        let info = notification.info
        if let frame = info.keyboardFrameEnd,
            let duration = info.duration,
            let curve = info.curve {

            UIView.animate(withDuration: duration, delay: 0, options: curve, animations: {
                self.containerViewBottom.constant = self.view.bounds.height - frame.origin.y
                self.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate Methods
extension AlertController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch preferredStyle {
        case .alert:
            return AlertControllerPresentTransition(backgroundColor: coverColor)
        case .actionSheet:
            return ActionSheetControllerPresentTransition(backgroundColor: coverColor)
        @unknown default:
            fatalError()
        }
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch preferredStyle {
        case .alert:
            return AlertControllerDismissTransition(backgroundColor: coverColor)
        case .actionSheet:
            return ActionSheetControllerDismissTransition(backgroundColor: coverColor)
        @unknown default:
            fatalError()
        }
    }
}
