//
//  AlertContentView.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2016/09/12.
//  Copyright © 2016年 kyohei_ito. All rights reserved.
//

import UIKit

open class AlertContentView: UIView {
    @IBOutlet open weak var baseView: UIView!
    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var messageLabel: UILabel!
    @IBOutlet open weak var textBackgroundView: UIView!
    
    @IBOutlet var verticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var titleSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var messageSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    
    var textFields: [UITextField] = []
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
    }

    func addTextField() -> UITextField {
        let textField = TextField(frame: textBackgroundView.bounds)
        textFields.append(textField)
        textBackgroundView.addSubview(textField)
        return textField
    }

    func layoutContents() {
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

        baseView.layoutIfNeeded()

        frame.size.height = baseView.bounds.height + (verticalSpaceConstraint.constant * 2)
    }
}
