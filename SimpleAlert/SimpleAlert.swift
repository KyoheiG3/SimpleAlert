//
//  SimpleAlert.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2015/01/09.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//

import UIKit

public class AlertAction : NSObject {
    public enum Style {
        case Default
        case OK
        case Cancel
        case Destructive
    }

    public init(title: String, style: AlertAction.Style, handler: ((AlertAction!) -> Void)? = nil) {
        self.title = title
        self.handler = handler
        self.style = style
        super.init()
    }
    
    private func setButton(forButton: UIButton) {
        button = forButton
        button.setTitle(title, forState: .Normal)
        button.enabled = enabled
    }
    
    var title: String
    var handler: ((AlertAction) -> Void)?
    var style: AlertAction.Style
    public var enabled: Bool = true {
        didSet {
            button.enabled = enabled
        }
    }
    public private(set) var button: UIButton!
}

public class ContentView: UIView {
    class ContentTextField: UITextField {
        let TextLeftOffset: CGFloat = 4
        override func textRectForBounds(bounds: CGRect) -> CGRect {
            return CGRectOffset(bounds, TextLeftOffset, 0)
        }
        
        override func editingRectForBounds(bounds: CGRect) -> CGRect {
            return CGRectOffset(bounds, TextLeftOffset, 0)
        }
    }
    
    let TextFieldFontSize: CGFloat = 14
    let TextFieldHeight: CGFloat = 25

    @IBOutlet public weak var baseView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var messageLabel: UILabel!
    @IBOutlet public weak var textBackgroundView: UIView!
    
    @IBOutlet var verticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var titleSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var messageSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    
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
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
    }
    
    public override func layoutSubviews() {
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
        
        super.layoutSubviews()
        
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

public class Controller: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainView: UIScrollView!
    @IBOutlet weak var buttonView: UIScrollView!
    @IBOutlet weak var contentView: ContentView?
    
    @IBOutlet private var containerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var containerViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet private var backgroundViewBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var buttonViewHeightConstraint: NSLayoutConstraint!
    
    public var configContainerWidth: ((UIView!) -> CGFloat?)?
    public var configContentView: ((UIView!) -> Void)?
    
    public private(set) var actions: [AlertAction] = []
    public private(set) var textFields: [UITextField] = []
    var textFieldHandlers: [((UITextField!) -> Void)?] = []
    weak var customView: UIView?
    var displayTargetView: UIView?
    let ButtonHeight: CGFloat = 48
    let ButtonFontSize: CGFloat = 17
    var animator: UIDynamicAnimator?
    var presentedAnimation: Bool = true
    var keyboardHeight: CGFloat = 0
    
    var message: String?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public convenience init(title: String?, message: String?) {
        self.init()
        self.title = title
        self.message = message
    }
    
    public convenience init(view: UIView?) {
        self.init()
        self.customView = view
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String? = "SimpleAlert", bundle nibBundleOrNil: NSBundle? = NSBundle(forClass: Controller.self)) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .Custom
        modalTransitionStyle = .CrossDissolve
        transitioningDelegate = self
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        
        containerView.layer.cornerRadius = 3.0
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.lightGrayColor()
        
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
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundViewBottomSpaceConstraint.constant = keyboardHeight
        
        layoutContainer()
        layoutContents()
        layoutButtons()
        
        if buttonView.contentSize.height > buttonViewHeightConstraint.constant {
            buttonViewHeightConstraint.constant = buttonView.contentSize.height
        }
        
        let backgroundViewHeight = view.bounds.size.height - keyboardHeight
        if buttonViewHeightConstraint.constant > backgroundViewHeight {
            buttonView.contentSize.height = buttonViewHeightConstraint.constant
            buttonViewHeightConstraint.constant = backgroundViewHeight
            mainViewHeightConstraint.constant = 0
        } else {
            let mainViewHeight = backgroundViewHeight - buttonViewHeightConstraint.constant
            if mainViewHeightConstraint.constant > mainViewHeight {
                mainView.contentSize.height = mainViewHeightConstraint.constant
                mainViewHeightConstraint.constant = mainViewHeight
            }
        }
        
        view.layoutSubviews()
    }
    
    public func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)? = nil) {
        textFieldHandlers.append(configurationHandler)
    }
    
    public func addAction(action: AlertAction) {
        let button = defaultButton(ButtonHeight)
        button.addTarget(self, action: "buttonWasTapped:", forControlEvents: .TouchUpInside)
        action.setButton(button)
        configurButton(action.style, forButton: button)
        actions.append(action)
    }
    
    public func configurButton(style :AlertAction.Style, forButton button: UIButton) {
        switch style {
        case .Destructive:
            button.setTitleColor(UIColor.redColor(), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(ButtonFontSize)
        case .Cancel:
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(ButtonFontSize)
        default:
            button.titleLabel?.font = UIFont.systemFontOfSize(ButtonFontSize)
        }
    }
    
    func setupContnetView() {
        takeOverColor(contentView)
        
        contentView?.titleLabel.text = title
        contentView?.messageLabel.text = message
        
        textFieldHandlers.map() { handler -> Void in
            if let textField = self.contentView?.addTextField() {
                self.textFields.append(textField)
                handler?(textField)
            }
        }
    }
    
    func layoutContainer() {
        if let width = configContainerWidth?(containerView) {
            containerViewWidthConstraint.constant = width
            containerView.frame.size.width = width
        }
        
        buttonView.frame.size.width = containerView.frame.size.width
        mainView.frame.size.width = containerView.frame.size.width
    }
    
    func layoutContents() {
        if let config = configContentView {
            config(displayTargetView)
            configContentView = nil
            
            takeOverColor(displayTargetView)
        }
        
        if displayTargetView == contentView {
            contentView?.textViewHeightConstraint.constant = 0
            textFields.map { self.contentView?.layoutTextField($0) }
            contentView?.setNeedsLayout()
            contentView?.layoutIfNeeded()
        }
        
        if let targetView = displayTargetView {
            mainViewHeightConstraint.constant = targetView.bounds.height
            mainView.frame.size.height = targetView.bounds.height
            mainView.addSubview(targetView)
            
            targetView.frame.size.width = mainView.frame.size.width
        }
    }
    
    func layoutButtons() {
        var sizeToFit: ((button: UIButton, index: Int) -> Void) = buttonSizeToFitForVertical
        if actions.count == 2 {
            sizeToFit = buttonSizeToFitForHorizontal
        }
        
        let buttonCount = actions.reduce(0) { index, action in
            let button = action.button
            self.buttonView.addSubview(button)
            sizeToFit(button: button, index: index)
            return index + 1
        }
        
        if actions.count != 2 {
            buttonViewHeightConstraint.constant = ButtonHeight * CGFloat(buttonCount)
        }
    }
    
    func takeOverColor(targetView: UIView?) {
        mainView.backgroundColor = targetView?.backgroundColor
        buttonView.backgroundColor = targetView?.backgroundColor
        targetView?.backgroundColor = nil
    }
    
    func defaultButton(height: CGFloat) -> UIButton {
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
        borderView.backgroundColor = UIColor.lightGrayColor()
        borderView.autoresizingMask = .FlexibleWidth
        
        let button = UIButton.buttonWithType(.System) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 0, height: height)
        button.autoresizingMask = .FlexibleWidth
        button.addSubview(borderView)
        
        return button
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
}

// MARK: - Action Methods
extension Controller {
    func buttonWasTapped(sender: UIButton) {
        dismissViewControllerAnimated(true) {
            if let action = self.actions.filter({ $0.button == sender }).first {
                action.handler?(action)
            }
            
            self.actions.removeAll()
            self.textFields.removeAll()
        }
    }
}

// MARK: - NSNotificationCenter Methods
extension Controller {
    func keyboardWillShow(notification: NSNotification) {
        if let window = view.window {
            if let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
                let rect = window.convertRect(frame, toView: view)
                
                keyboardHeight = view.bounds.size.height - rect.origin.y
            }
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        backgroundViewBottomSpaceConstraint.constant = keyboardHeight
    }
}

// MARK: - UIViewControllerTransitioningDelegate Methods
extension Controller: UIViewControllerTransitioningDelegate {
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
extension Controller: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) {
            if let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) {
                let container = transitionContext.containerView()
                
                if presentedAnimation == true {
                    animationForPresented(container, toView: to.view, fromView: from.view) { _ in
                        transitionContext.completeTransition(true)
                    }
                } else {
                    animationForDismissed(container, toView: to.view, fromView: from.view) { _ in
                        transitionContext.completeTransition(true)
                    }
                }
            }
        }
    }
    
    func animationForPresented(container: UIView, toView: UIView, fromView: UIView, completion: (Bool) -> Void) {
        var frame = fromView.frame
        frame.origin = CGPoint.zeroPoint
        toView.frame = frame
        container.addSubview(toView)
        
        toView.alpha = 0
        toView.transform = CGAffineTransformConcat(fromView.transform, CGAffineTransformMakeScale(1.2, 1.2))
        
        UIView.animateWithDuration(0.25, animations: {
            toView.transform = fromView.transform
            toView.alpha = 1
        }, completion: completion)
    }
    
    func animationForDismissed(container: UIView, toView: UIView, fromView: UIView, completion: (Bool) -> Void) {
        container.addSubview(fromView)
        
        UIView.animateWithDuration(0.25, animations: {
            fromView.alpha = 0
        }, completion: completion)
    }
}
