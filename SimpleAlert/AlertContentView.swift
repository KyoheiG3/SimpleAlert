//
//  AlertContentView.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2016/09/12.
//  Copyright © 2016年 kyohei_ito. All rights reserved.
//

import UIKit

open class AlertContentView: UIView {
    @IBOutlet public private(set) weak var contentStackView: UIStackView!
    @IBOutlet public private(set) weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = nil
            titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }
    @IBOutlet public private(set) weak var messageLabel: UILabel! {
        didSet {
            messageLabel.text = nil
            messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }
    @IBOutlet public private(set) weak var textBackgroundView: UIView!
    @IBOutlet private weak var textFieldView: UIView!
    @IBOutlet private weak var textFieldStackView: UIStackView!

    var textFields: [UITextField] {
        return textFieldStackView?.arrangedSubviews.compactMap { $0 as? UITextField } ?? []
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.isHidden = titleLabel.text?.isEmpty ?? true
        messageLabel.isHidden = messageLabel.text?.isEmpty ?? true
        textFieldView.isHidden = textFields.isEmpty
        contentStackView.arrangedSubviews[0].isHidden = titleLabel.isHidden && messageLabel.isHidden && textFieldView.isHidden
        isHidden = contentStackView.arrangedSubviews.allSatisfy(\.isHidden)
        superview?.isHidden = isHidden

        let labelMaxLayoutWidth = bounds.width - 32
        titleLabel.preferredMaxLayoutWidth = labelMaxLayoutWidth
        messageLabel.preferredMaxLayoutWidth = labelMaxLayoutWidth
    }

    func append(_ textField: UITextField) {
        textFieldStackView.addArrangedSubview(textField)
    }

    func removeAllTextField() {
        textFieldStackView.removeAllArrangedSubviews()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }

    private func loadNibContent() {
        let type = AlertContentView.self
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: type)
        #endif
        let nib = UINib(nibName: String(describing: type), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leftAnchor.constraint(equalTo: leftAnchor),
                view.rightAnchor.constraint(equalTo: rightAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
        }
    }
}
