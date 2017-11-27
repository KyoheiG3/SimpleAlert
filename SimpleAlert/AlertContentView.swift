//
//  AlertContentView.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2016/09/12.
//  Copyright © 2016年 kyohei_ito. All rights reserved.
//

import UIKit

open class AlertContentView: UIView {
    @IBOutlet public weak var baseView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var messageLabel: UILabel!
    @IBOutlet public weak var textBackgroundView: UIView!
    @IBOutlet public weak var containerView: UIView!

    @IBOutlet var verticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var titleSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var messageSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var containerViewHeight: NSLayoutConstraint!

    var textFields: [UITextField] = []

    func addTextField() -> UITextField {
        let textField = TextField(frame: textBackgroundView.bounds)
        textFields.append(textField)
        textBackgroundView.addSubview(textField)
        return textField
    }

    func layoutContents() {
        textViewHeightConstraint.constant = 0
        for textField in textFields {
            textField.frame.origin.y = textViewHeightConstraint.constant
            if textField.frame.height <= 0 {
                textField.frame.size.height = 25
            }
            textViewHeightConstraint.constant += textField.frame.height
        }

        titleLabel.preferredMaxLayoutWidth = baseView.bounds.width
        messageLabel.preferredMaxLayoutWidth = baseView.bounds.width

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

        if let view = containerView.subviews.sorted(by: { $0.frame.maxY > $1.frame.maxY }).first {
            containerViewHeight.constant = view.frame.maxY
        }
        baseView.layoutIfNeeded()

        frame.size.height = baseView.bounds.height + (verticalSpaceConstraint.constant * 2) + containerViewHeight.constant
    }
    
    func addHorizontalBorder() {
        let borderView = UIView(frame: CGRect(x: 0, y: -CGFloat.thinWidth, width: containerView.bounds.width, height: CGFloat.thinWidth))
        borderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        borderView.autoresizingMask = .flexibleWidth
        containerView.addSubview(borderView)
    }
}
