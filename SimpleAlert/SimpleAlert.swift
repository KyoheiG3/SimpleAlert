//
//  SimpleAlert.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2015/01/09.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//

import UIKit

open class AlertController: UIViewController {
    public enum Style {
        case alert
        case actionSheet

        var fontSize: CGFloat {
            switch self {
            case .alert: return 17
            case .actionSheet: return 21
            }
        }

        var buttonHeight: CGFloat {
            switch self {
            case .alert: return 48
            case .actionSheet: return 44
            }
        }
    }

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var backgroundView: UIView! {
        didSet {
            if preferredStyle == .actionSheet {
                tapGesture.addTarget(self, action: #selector(AlertController.backgroundViewTapAction(_:)))
                backgroundView.addGestureRecognizer(tapGesture)
            }
        }
    }
    @IBOutlet fileprivate weak var marginView: UIView!
    @IBOutlet fileprivate weak var baseView: UIView! {
        didSet {
            baseView.layer.cornerRadius = 3.0
            baseView.clipsToBounds = true
        }
    }
    @IBOutlet fileprivate weak var mainView: UIScrollView!
    @IBOutlet fileprivate weak var buttonView: UIScrollView!
    @IBOutlet fileprivate weak var cancelButtonView: UIScrollView! {
        didSet {
            cancelButtonView.layer.cornerRadius = 3.0
            cancelButtonView.clipsToBounds = true
        }
    }
    @IBOutlet fileprivate weak var contentView: AlertContentView?
    
    @IBOutlet fileprivate var containerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var containerViewBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var backgroundViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var backgroundViewBottomSpaceConstraint: NSLayoutConstraint!

    @IBOutlet fileprivate var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var buttonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var cancelButtonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var buttonViewSpaceConstraint: NSLayoutConstraint! {
        didSet {
            if preferredStyle == .actionSheet {
                buttonViewSpaceConstraint.constant = ActionSheetMargin
            }
        }
    }
    
    @IBOutlet fileprivate var marginViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var marginViewLeftSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var marginViewBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var marginViewRightSpaceConstraint: NSLayoutConstraint!
    
    open var configContainerWidth: (() -> CGFloat?)?
    open var configContainerCornerRadius: (() -> CGFloat?)?
    open var configContentView: ((UIView?) -> Void)?
    
    open fileprivate(set) var actions: [AlertAction] = []
    public var textFields: [UITextField] {
        return contentView?.textFields ?? []
    }
    open var coverColor: UIColor = .black
    open var message: String?

    private var textFieldHandlers: [((UITextField) -> Void)?] = []
    private var customView: UIView?
    private var displayTargetView: UIView?
    private var preferredStyle: Style = .alert
    private let tapGesture = UITapGestureRecognizer()
    let AlertDefaultWidth: CGFloat = 270
    let ActionSheetMargin: CGFloat = 8

    private var marginInsets: UIEdgeInsets {
        set {
            marginViewLeftSpaceConstraint.constant = newValue.left
            marginViewRightSpaceConstraint.constant = newValue.right
            if #available(iOS 11.0, *) {
                marginViewTopSpaceConstraint.constant = view.safeAreaInsets.top
                marginViewBottomSpaceConstraint.constant = view.safeAreaInsets.bottom
            } else {
                let height = UIApplication.shared.statusBarFrame.height
                marginViewTopSpaceConstraint.constant = height == 0 ? newValue.top : height
                marginViewBottomSpaceConstraint.constant = newValue.bottom
            }
        }
        get {
            let top = marginViewTopSpaceConstraint.constant
            let left = marginViewLeftSpaceConstraint.constant
            let bottom = marginViewBottomSpaceConstraint.constant
            let right = marginViewRightSpaceConstraint.constant
            return UIEdgeInsetsMake(top, left, bottom, right)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private convenience init() {
        self.init(nibName: "SimpleAlert", bundle: Bundle(for: AlertController.self))
    }

    public convenience init(title: String?, message: String?, style: Style) {
        self.init()
        self.title = title
        self.message = message
        self.preferredStyle = style
    }

    public convenience init(view: UIView?, style: Style) {
        self.init()
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

        NotificationCenter.default.addObserver(self, selector: #selector(AlertController.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlertController.keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            mainView.contentInsetAdjustmentBehavior = .never
            buttonView.contentInsetAdjustmentBehavior = .never
            cancelButtonView.contentInsetAdjustmentBehavior = .never
        }

        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        displayTargetView = contentView
        containerViewBottomSpaceConstraint.isActive = preferredStyle == .actionSheet
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let view = customView {
            displayTargetView = view
        }

        if displayTargetView == contentView {
            setupContnetView()
        }
        textFieldHandlers.removeAll()
        textFields.first?.becomeFirstResponder()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutContainer()
        layoutContents()
        layoutButtons()

        let margin = marginInsets.top + marginInsets.bottom
        let backgroundViewHeight = view.bounds.size.height - backgroundViewBottomSpaceConstraint.constant - margin
        
        if cancelButtonView.contentSize.height > cancelButtonViewHeightConstraint.constant {
            cancelButtonViewHeightConstraint.constant = cancelButtonView.contentSize.height
        }
        
        if cancelButtonViewHeightConstraint.constant > backgroundViewHeight {
            cancelButtonView.contentSize.height = cancelButtonViewHeightConstraint.constant
            cancelButtonViewHeightConstraint.constant = backgroundViewHeight
            
            mainViewHeightConstraint.constant = 0
            buttonViewHeightConstraint.constant = 0
        } else {
            let baseViewHeight = backgroundViewHeight - cancelButtonViewHeightConstraint.constant - buttonViewSpaceConstraint.constant
            if buttonView.contentSize.height > buttonViewHeightConstraint.constant {
                buttonViewHeightConstraint.constant = buttonView.contentSize.height
            }
            
            if buttonViewHeightConstraint.constant > baseViewHeight {
                buttonView.contentSize.height = buttonViewHeightConstraint.constant
                buttonViewHeightConstraint.constant = baseViewHeight
                mainViewHeightConstraint.constant = 0
            } else {
                let mainViewHeight = baseViewHeight - buttonViewHeightConstraint.constant
                if mainViewHeightConstraint.constant > mainViewHeight {
                    mainView.contentSize.height = mainViewHeightConstraint.constant
                    mainViewHeightConstraint.constant = mainViewHeight
                }
            }
        }
    }

    open func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        textFieldHandlers.append(configurationHandler)
    }

    open func addAction(_ action: AlertAction) {
        action.button.frame.size.height = preferredStyle.buttonHeight
        action.button.addTarget(self, action: #selector(AlertController.buttonWasTapped(_:)), for: .touchUpInside)

        configureActionButton(action.button, at: action.style)
        actions.append(action)
    }

    open func configureActionButton(_ button: UIButton, at style: AlertAction.Style) {
        if style == .destructive {
            button.setTitleColor(.red, for: .normal)
        }
        button.titleLabel?.font = style.font(of: preferredStyle)
    }
}

private extension AlertController {
    func setupContnetView() {
        takeOverColor(contentView)
        
        contentView?.titleLabel.text = title
        contentView?.messageLabel.text = message
        
        if preferredStyle == .alert, let contentView = contentView {
            for handler in textFieldHandlers {
                handler?(contentView.addTextField())
            }
        }
    }
    
    func layoutContainer() {
        let containerWidth: CGFloat
        if preferredStyle == .actionSheet {
            marginInsets = UIEdgeInsetsMake(ActionSheetMargin, ActionSheetMargin, ActionSheetMargin, ActionSheetMargin)
            containerWidth = min(view.bounds.width, view.bounds.height) - marginInsets.left - marginInsets.right
        } else {
            containerWidth = configContainerWidth?() ?? AlertDefaultWidth
        }
        
        if let radius = configContainerCornerRadius?() {
            baseView.layer.cornerRadius = radius
            cancelButtonView.layer.cornerRadius = radius
        }
        
        containerViewWidthConstraint.constant = containerWidth
        containerView.layoutIfNeeded()
    }
    
    func layoutContents() {
        displayTargetView?.frame.size.width = mainView.frame.size.width

        if let config = configContentView {
            config(displayTargetView)
            configContentView = nil
        }
        takeOverColor(displayTargetView)
        
        if displayTargetView == contentView {
            contentView?.textViewHeightConstraint.constant = 0
            contentView?.layoutContents()
        }
        
        if let targetView = displayTargetView {
            mainViewHeightConstraint.constant = targetView.bounds.height
            mainView.frame.size.height = targetView.bounds.height
            mainView.addSubview(targetView)
        }
    }
    
    func layoutButtons() {
        let containerWidth = containerViewWidthConstraint.constant
        let buttonActions: [AlertAction]

        if preferredStyle == .actionSheet {
            let cancelActions = actions.filter { $0.style == .cancel }
            layoutButtonVertically(with: cancelActions, width: containerWidth).forEach(cancelButtonView.addAction)
            cancelButtonViewHeightConstraint.constant = cancelActions.last?.button.frame.maxY ?? 0

            buttonActions = actions.filter { $0.style != .cancel }
        } else {
            buttonActions = actions
        }

        if preferredStyle == .alert && actions.count == 2 {
            layoutButtonHorizontally(with: buttonActions, width: containerWidth / 2).forEach(buttonView.addAction)
            buttonActions.last?.addVerticalBorder()
        } else {
            layoutButtonVertically(with: buttonActions, width: containerWidth).forEach(buttonView.addAction)
        }
        buttonViewHeightConstraint.constant = buttonActions.last?.button.frame.maxY ?? 0
    }

    func layoutButtonVertically(with actions: [AlertAction], width: CGFloat) -> [AlertAction] {
        return actions
            .reduce([]) { actions, action -> [AlertAction] in
                action.button.frame.size.width = width
                action.button.frame.origin.y = actions.last?.button.frame.maxY ?? 0
                return actions + [action]
            }
    }

    func layoutButtonHorizontally(with actions: [AlertAction], width: CGFloat) -> [AlertAction] {
        return actions
            .reduce([]) { actions, action -> [AlertAction] in
                action.button.frame.size.width = width
                action.button.frame.origin.x = actions.last?.button.frame.maxX ?? 0
                return actions + [action]
        }
    }

    func takeOverColor(_ targetView: UIView?) {
        if let color = targetView?.backgroundColor {
            mainView.backgroundColor = color
            buttonView.backgroundColor = color
            cancelButtonView.backgroundColor = color
        }
        targetView?.backgroundColor = nil
    }

    func dismiss(with sender: UIButton) {
        guard let action = actions.filter({ $0.button == sender }).first else {
            dismiss()
            return
        }
        if action.dismissesAlert {
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
            self.contentView?.textFields.removeAll()
        }
    }
}

// MARK: - Action Methods
private extension AlertController {
    @objc func buttonWasTapped(_ button: UIButton) {
        dismiss(with: button)
    }

    @objc func backgroundViewTapAction(_ gesture: UITapGestureRecognizer) {
        dismiss()
    }
}

// MARK: - NSNotificationCenter Methods
extension AlertController {
    @objc func keyboardDidHide(_ notification: Notification) {
        backgroundViewBottomSpaceConstraint?.constant = 0
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let frame = notification.info.endFrame, let rect = view.window?.convert(frame, to: view) {
            backgroundViewBottomSpaceConstraint?.constant = view.bounds.size.height - rect.origin.y
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
            return ActionSheetControllerPresentTransition(backgroundColor: coverColor, topSpace: self.backgroundViewTopSpaceConstraint, bottomSpace: self.backgroundViewBottomSpaceConstraint)
        }
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch preferredStyle {
        case .alert:
            return AlertControllerDismissTransition(backgroundColor: coverColor)
        case .actionSheet:
            return ActionSheetControllerDismissTransition(backgroundColor: coverColor, topSpace: self.backgroundViewTopSpaceConstraint, bottomSpace: self.backgroundViewBottomSpaceConstraint)
        }
    }
}
