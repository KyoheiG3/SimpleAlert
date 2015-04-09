//
//  SimpleAlert.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2015/01/09.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//

import UIKit

public class SimpleAlert {
    @objc(SimpleAlertAction)
    public class Action : NSObject {
        public enum Style {
            case Default
            case OK
            case Cancel
            case Destructive
        }
        
        public init(title: String, style: Style, handler: ((Action!) -> Void)? = nil) {
            self.title = title
            self.handler = handler
            self.style = style
            super.init()
        }
        
        var title: String
        var handler: ((Action) -> Void)?
        var style: Action.Style
        public var enabled: Bool = true {
            didSet {
                button?.enabled = enabled
            }
        }
        public private(set) var button: UIButton!
    }
    
    @objc(SimpleAlertContentView)
    public class ContentView: UIView {
        let TextFieldFontSize: CGFloat = 14
        let TextFieldHeight: CGFloat = 25
        
        @IBOutlet public weak var baseView: UIView!
        @IBOutlet public weak var titleLabel: UILabel!
        @IBOutlet public weak var messageLabel: UILabel!
        @IBOutlet public weak var textBackgroundView: UIView!
        
        @IBOutlet private var verticalSpaceConstraint: NSLayoutConstraint!
        @IBOutlet private var titleSpaceConstraint: NSLayoutConstraint!
        @IBOutlet private var messageSpaceConstraint: NSLayoutConstraint!
        @IBOutlet private var textViewHeightConstraint: NSLayoutConstraint!
        
        public override func awakeFromNib() {
            super.awakeFromNib()
            
            backgroundColor = UIColor.whiteColor()
        }
    }
    
    @objc(SimpleAlertController)
    public class Controller: UIViewController {
        public enum Style {
            case Alert
            case ActionSheet
        }
        
        @objc(SimpleAlertControllerRespondView)
        private class RespondView: UIView {
            var touchHandler: ((UIView) -> Void)?
            override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
                touchHandler?(self)
            }
        }
        
        @IBOutlet private weak var containerView: UIView!
        @IBOutlet private weak var backgroundView: RespondView!
        @IBOutlet private weak var coverView: UIView!
        @IBOutlet private weak var marginView: UIView!
        @IBOutlet private weak var baseView: UIView!
        @IBOutlet private weak var mainView: UIScrollView!
        @IBOutlet private weak var buttonView: UIScrollView!
        @IBOutlet private weak var cancelButtonView: UIScrollView!
        @IBOutlet private weak var contentView: ContentView?
        
        @IBOutlet private var containerViewWidthConstraint: NSLayoutConstraint!
        @IBOutlet private var containerViewBottomSpaceConstraint: NSLayoutConstraint!
        @IBOutlet private var backgroundViewTopSpaceConstraint: NSLayoutConstraint!
        @IBOutlet private var backgroundViewBottomSpaceConstraint: NSLayoutConstraint!
        @IBOutlet private var coverViewHeightConstraint: NSLayoutConstraint!
        
        @IBOutlet private var mainViewHeightConstraint: NSLayoutConstraint!
        @IBOutlet private var buttonViewHeightConstraint: NSLayoutConstraint!
        @IBOutlet private var cancelButtonViewHeightConstraint: NSLayoutConstraint!
        @IBOutlet private var buttonViewSpaceConstraint: NSLayoutConstraint!
        
        @IBOutlet private var marginViewTopSpaceConstraint: NSLayoutConstraint!
        @IBOutlet private var marginViewLeftSpaceConstraint: NSLayoutConstraint!
        @IBOutlet private var marginViewBottomSpaceConstraint: NSLayoutConstraint!
        @IBOutlet private var marginViewRightSpaceConstraint: NSLayoutConstraint!
        
        public var configContainerWidth: (() -> CGFloat?)?
        public var configContainerCornerRadius: (() -> CGFloat?)?
        public var configContentView: ((UIView!) -> Void)?
        
        public private(set) var actions: [Action] = []
        public private(set) var textFields: [UITextField] = []
        private var textFieldHandlers: [((UITextField!) -> Void)?] = []
        private var customView: UIView?
        private var transitionCoverView: UIView?
        private var displayTargetView: UIView?
        private var presentedAnimation: Bool = true
        let AlertDefaultWidth: CGFloat = 270
        let AlertButtonHeight: CGFloat = 48
        let AlertButtonFontSize: CGFloat = 17
        let ActionSheetMargin: CGFloat = 8
        let ActionSheetButtonHeight: CGFloat = 44
        let ActionSheetButtonFontSize: CGFloat = 21
        let ConstraintPriorityRequired: Float = 1000
        
        private var message: String?
        private var preferredStyle: Style = .Alert
        
        private var marginInsets: UIEdgeInsets {
            set {
                marginViewTopSpaceConstraint.constant = newValue.top
                marginViewLeftSpaceConstraint.constant = newValue.left
                marginViewBottomSpaceConstraint.constant = newValue.bottom
                marginViewRightSpaceConstraint.constant = newValue.right
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
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
        public convenience init() {
            self.init(nibName: "SimpleAlert", bundle: NSBundle(forClass: Controller.self))
        }
        
        public convenience init(title: String?, message: String?, style: Style) {
            self.init()
            self.title = title
            self.message = message
            self.preferredStyle = style
        }
        
        public convenience init(view: UIView?, style: Style) {
            self.init()
            self.customView = view
            self.preferredStyle = style
        }
        
        public required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            
            modalPresentationStyle = .Custom
            modalTransitionStyle = .CrossDissolve
            transitioningDelegate = self
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            
            baseView.layer.cornerRadius = 3.0
            baseView.clipsToBounds = true
            
            cancelButtonView.layer.cornerRadius = 3.0
            cancelButtonView.clipsToBounds = true
            
            displayTargetView = contentView
        }
        
        public override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            if let view = customView {
                displayTargetView = view
            }
            
            if displayTargetView == contentView {
                setupContnetView()
            }
            textFieldHandlers.removeAll()
            
            if let textField = textFields.first {
                textField.becomeFirstResponder()
            }
            
            if preferredStyle == .ActionSheet {
                containerViewBottomSpaceConstraint.priority = ConstraintPriorityRequired
                backgroundView.touchHandler = { [weak self] view in
                    self?.dismissViewController()
                    return
                }
            }
        }
        
        public override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            if transitionCoverView == nil {
                return
            }
            
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
            
            if preferredStyle == .ActionSheet {
                let contentHeight = cancelButtonViewHeightConstraint.constant + mainViewHeightConstraint.constant + buttonViewHeightConstraint.constant + buttonViewSpaceConstraint.constant
                coverViewHeightConstraint.constant = contentHeight + marginInsets.top + marginInsets.bottom
            }
            
            view.layoutSubviews()
        }
        
        public func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)? = nil) {
            textFieldHandlers.append(configurationHandler)
        }
        
        public func addAction(action: Action) {
            var buttonHeight: CGFloat!
            if preferredStyle == .ActionSheet {
                buttonHeight = ActionSheetButtonHeight
            } else {
                buttonHeight = AlertButtonHeight
            }
            
            let button = loadButton()
            if button.bounds.height <= 0 {
                button.frame.size.height = buttonHeight
            }
            button.autoresizingMask = .FlexibleWidth
            button.addTarget(self, action: "buttonWasTapped:", forControlEvents: .TouchUpInside)
            action.setButton(button)
            configurButton(action.style, forButton: button)
            actions.append(action)
        }
        
        /** override if needed */
        public func loadButton() -> UIButton {
            let button = UIButton.buttonWithType(.System) as! UIButton
            let borderView = UIView(frame: CGRect(x: 0, y: -0.5, width: 0, height: 0.5))
            borderView.backgroundColor = UIColor.lightGrayColor()
            borderView.autoresizingMask = .FlexibleWidth
            button.addSubview(borderView)
            
            return button
        }
        
        public func configurButton(style: Action.Style, forButton button: UIButton) {
            if preferredStyle == .Alert {
                configurAlertButton(style, forButton: button)
            } else {
                configurActionSheetButton(style, forButton: button)
            }
        }
    }
}

private extension SimpleAlert.Action {
    private func setButton(forButton: UIButton) {
        button = forButton
        button.setTitle(title, forState: .Normal)
        button.enabled = enabled
    }
}

private extension SimpleAlert.ContentView {
    class ContentTextField: UITextField {
        let TextLeftOffset: CGFloat = 4
        override func textRectForBounds(bounds: CGRect) -> CGRect {
            return CGRectOffset(bounds, TextLeftOffset, 0)
        }
        
        override func editingRectForBounds(bounds: CGRect) -> CGRect {
            return CGRectOffset(bounds, TextLeftOffset, 0)
        }
    }
    
    func addTextField() -> UITextField {
        let textField = ContentTextField(frame: textBackgroundView.bounds)
        textField.autoresizingMask = .FlexibleWidth
        textField.font = UIFont.systemFontOfSize(TextFieldFontSize)
        textField.backgroundColor = UIColor.whiteColor()
        textField.layer.borderColor = UIColor.darkGrayColor().CGColor
        textField.layer.borderWidth = 0.5
        
        textBackgroundView.addSubview(textField)
        
        return textField
    }
    
    func layoutContents() {
        titleLabel.preferredMaxLayoutWidth = baseView.bounds.width
        titleLabel.layoutIfNeeded()
        messageLabel.preferredMaxLayoutWidth = baseView.bounds.width
        messageLabel.layoutIfNeeded()
        
        if textBackgroundView.subviews.isEmpty {
            messageSpaceConstraint.constant = 0
        }
        
        if titleLabel.text == nil && messageLabel.text == nil {
            titleSpaceConstraint.constant = 0
            messageSpaceConstraint.constant = 0
            
            if textBackgroundView.subviews.isEmpty {
                verticalSpaceConstraint.constant = 0
            }
        } else if titleLabel.text == nil || messageLabel.text == nil {
            titleSpaceConstraint.constant = 0
        }
        
        baseView.layoutIfNeeded()
        
        frame.size.height = baseView.bounds.height + (verticalSpaceConstraint.constant * 2)
    }
    
    func layoutTextField(textField: UITextField) {
        textField.frame.origin.y = textViewHeightConstraint.constant
        if textField.frame.height <= 0 {
            textField.frame.size.height = TextFieldHeight
        }
        textViewHeightConstraint.constant += textField.frame.height
    }
}

private extension SimpleAlert.Controller {
    func setupContnetView() {
        takeOverColor(contentView)
        
        contentView?.titleLabel.text = title
        contentView?.messageLabel.text = message
        
        if preferredStyle == .Alert {
            textFieldHandlers.map() { handler -> Void in
                if let textField = self.contentView?.addTextField() {
                    self.textFields.append(textField)
                    handler?(textField)
                }
            }
        }
    }
    
    func layoutContainer() {
        var containerWidth = AlertDefaultWidth
        if preferredStyle == .ActionSheet {
            marginInsets = UIEdgeInsetsMake(ActionSheetMargin, ActionSheetMargin, ActionSheetMargin, ActionSheetMargin)
            marginView.layoutIfNeeded()
            containerWidth = min(view.bounds.width, view.bounds.height) - marginInsets.top - marginInsets.bottom
        }
        
        if let width = configContainerWidth?() {
            containerWidth = width
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
        displayTargetView?.layoutIfNeeded()
        
        if let config = configContentView {
            config(displayTargetView)
            configContentView = nil
        }
        takeOverColor(displayTargetView)
        
        if displayTargetView == contentView {
            contentView?.textViewHeightConstraint.constant = 0
            textFields.map { self.contentView?.layoutTextField($0) }
            contentView?.layoutContents()
        }
        
        if let targetView = displayTargetView {
            mainViewHeightConstraint.constant = targetView.bounds.height
            mainView.frame.size.height = targetView.bounds.height
            mainView.addSubview(targetView)
        }
    }
    
    func layoutButtons() {
        var buttonActions = actions
        if preferredStyle == .ActionSheet {
            let cancelActions = actions.filter { $0.style == .Cancel }
            let buttonHeight = addButton(cancelButtonView, actions: cancelActions)
            cancelButtonViewHeightConstraint.constant = buttonHeight
            buttonViewSpaceConstraint.constant = ActionSheetMargin
            
            buttonActions = actions.filter { $0.style != .Cancel }
        }
        
        let buttonHeight = addButton(buttonView, actions: buttonActions)
        if preferredStyle != .Alert || buttonActions.count != 2 {
            buttonViewHeightConstraint.constant = buttonHeight
        }
    }
    
    func takeOverColor(targetView: UIView?) {
        if let color = targetView?.backgroundColor {
            mainView.backgroundColor = color
            buttonView.backgroundColor = color
            cancelButtonView.backgroundColor = color
        }
        targetView?.backgroundColor = nil
    }
    
    func addButton(view: UIView, actions: [SimpleAlert.Action]) -> CGFloat {
        var sizeToFit: ((button: UIButton, index: Int) -> Void) = buttonSizeToFitForVertical
        if preferredStyle == .Alert && actions.count == 2 {
            sizeToFit = buttonSizeToFitForHorizontal
        }
        
        return actions.reduce(0) { height, action in
            let button = action.button
            view.addSubview(button)
            
            let buttonHeight = Int(button.bounds.height)
            let buttonsHeight = Int(height)
            sizeToFit(button: button, index: buttonsHeight / buttonHeight)
            
            return CGFloat(buttonsHeight + buttonHeight)
        }
    }
    
    func buttonSizeToFitForVertical(button: UIButton, index: Int) {
        button.frame.size.width = containerViewWidthConstraint.constant
        button.frame.origin.y = button.bounds.height * CGFloat(index)
    }
    
    func buttonSizeToFitForHorizontal(button: UIButton, index: Int) {
        button.frame.size.width = containerViewWidthConstraint.constant / 2
        button.frame.origin.x = button.bounds.width * CGFloat(index)
        
        if index != 0 {
            let borderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.5, height: button.bounds.height))
            borderView.backgroundColor = UIColor.lightGrayColor()
            borderView.autoresizingMask = .FlexibleHeight
            button.addSubview(borderView)
        }
    }
    
    func configurAlertButton(style :SimpleAlert.Action.Style, forButton button: UIButton) {
        switch style {
        case .Destructive:
            button.setTitleColor(UIColor.redColor(), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(AlertButtonFontSize)
        case .Cancel:
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(AlertButtonFontSize)
        default:
            button.titleLabel?.font = UIFont.systemFontOfSize(AlertButtonFontSize)
        }
    }
    
    func configurActionSheetButton(style :SimpleAlert.Action.Style, forButton button: UIButton) {
        switch style {
        case .Destructive:
            button.setTitleColor(UIColor.redColor(), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(ActionSheetButtonFontSize)
        case .Cancel:
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(ActionSheetButtonFontSize)
        default:
            button.titleLabel?.font = UIFont.systemFontOfSize(ActionSheetButtonFontSize)
        }
    }
    
    func dismissViewController(sender: AnyObject? = nil) {
        dismissViewControllerAnimated(true) {
            if let action = self.actions.filter({ $0.button == sender as? UIButton }).first {
                action.handler?(action)
            }
            
            self.actions.removeAll()
            self.textFields.removeAll()
        }
    }
}

// MARK: - Action Methods
extension SimpleAlert.Controller {
    func buttonWasTapped(sender: UIButton) {
        dismissViewController(sender: sender)
    }
}

// MARK: - NSNotificationCenter Methods
extension SimpleAlert.Controller {
    func keyboardDidHide(notification: NSNotification) {
        backgroundViewBottomSpaceConstraint?.constant = 0
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let window = view.window {
            if let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
                let rect = window.convertRect(frame, toView: view)
                
                backgroundViewBottomSpaceConstraint?.constant = view.bounds.size.height - rect.origin.y
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate Methods
extension SimpleAlert.Controller: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentedAnimation = true
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentedAnimation = false
        return self
    }
}

// MARK: - UIViewControllerAnimatedTransitioning Methods
extension SimpleAlert.Controller: UIViewControllerAnimatedTransitioning {
    func animateDuration() -> NSTimeInterval {
        return 0.25
    }
    
    func animationOptionsForAnimationCurve(curve: UInt) -> UIViewAnimationOptions {
        return UIViewAnimationOptions(curve << 16)
    }
    
    func createCoverView(frame: CGRect) -> UIView {
        let coverView = UIView(frame: frame)
        coverView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        coverView.alpha = 0
        coverView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        return coverView
    }
    
    func animation(animations: () -> Void, completion: (Bool) -> Void) {
        UIView.animateWithDuration(animateDuration(), delay: 0, options: animationOptionsForAnimationCurve(7), animations: animations, completion: completion)
    }
    
    func presentAnimationForAlert(container: UIView, toView: UIView, fromView: UIView, completion: (Bool) -> Void) {
        let coverView = createCoverView(container.bounds)
        container.addSubview(coverView)
        
        toView.frame = container.bounds
        toView.transform = CGAffineTransformConcat(fromView.transform, CGAffineTransformMakeScale(1.2, 1.2))
        coverView.addSubview(toView)

        transitionCoverView = coverView

        animation({
            toView.transform = fromView.transform
            coverView.alpha = 1
            }, completion: completion)
    }
    
    func dismissAnimationForAlert(container: UIView, toView: UIView, fromView: UIView, completion: (Bool) -> Void) {
        transitionCoverView?.addSubview(fromView)
        
        animation({
            self.transitionCoverView?.alpha = 0
            self.transitionCoverView = nil
            }, completion: completion)
    }
    
    func presentAnimationForActionSheet(container: UIView, toView: UIView, fromView: UIView, completion: (Bool) -> Void) {
        let coverView = createCoverView(container.bounds)
        container.addSubview(coverView)
        toView.frame = container.bounds
        container.addSubview(toView)
        
        backgroundViewBottomSpaceConstraint.constant = -toView.bounds.height
        backgroundViewTopSpaceConstraint.constant = toView.bounds.height
        backgroundView.layoutIfNeeded()
        backgroundViewBottomSpaceConstraint.constant = 0
        backgroundViewTopSpaceConstraint.constant = 0
        
        transitionCoverView = coverView
        
        animation({
            self.backgroundView.layoutIfNeeded()
            coverView.alpha = 1
            }, completion: completion)
    }
    
    func dismissAnimationForActionSheet(container: UIView, toView: UIView, fromView: UIView, completion: (Bool) -> Void) {
        container.addSubview(fromView)
        
        backgroundViewBottomSpaceConstraint.constant = -toView.bounds.height
        backgroundViewTopSpaceConstraint.constant = toView.bounds.height
        
        animation({
            self.backgroundView.layoutIfNeeded()
            self.transitionCoverView?.alpha = 0
            self.transitionCoverView = nil
            }, completion: completion)
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return animateDuration()
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) {
            if let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) {
                let container = transitionContext.containerView()
                
                if presentedAnimation == true {
                    if preferredStyle == .Alert {
                        presentAnimationForAlert(container, toView: to.view, fromView: from.view) { _ in
                            transitionContext.completeTransition(true)
                        }
                    } else {
                        presentAnimationForActionSheet(container, toView: to.view, fromView: from.view) { _ in
                            transitionContext.completeTransition(true)
                        }
                    }
                } else {
                    if preferredStyle == .Alert {
                        dismissAnimationForAlert(container, toView: to.view, fromView: from.view) { _ in
                            transitionContext.completeTransition(true)
                        }
                    } else {
                        dismissAnimationForActionSheet(container, toView: to.view, fromView: from.view) { _ in
                            transitionContext.completeTransition(true)
                        }
                    }
                }
            }
        }
    }
}
