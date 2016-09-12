//
//  AlertContentView.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2016/09/12.
//  Copyright © 2016年 kyohei_ito. All rights reserved.
//

import UIKit

open class AlertContentView: UIView {
    let TextFieldFontSize: CGFloat = 14
    let TextFieldHeight: CGFloat = 25
    
    @IBOutlet open weak var baseView: UIView!
    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var messageLabel: UILabel!
    @IBOutlet open weak var textBackgroundView: UIView!
    
    @IBOutlet var verticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var titleSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var messageSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.white
    }
}
