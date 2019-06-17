//
//  UIStackViewExtension.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2019/06/15.
//  Copyright © 2019 kyohei_ito. All rights reserved.
//

import UIKit

extension UIStackView {
    func makeBorderView() -> UIView {
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)

        switch axis {
        case .horizontal:
            borderView.widthAnchor.constraint(equalToConstant: CGFloat.thinWidth).isActive = true
        case .vertical:
            borderView.heightAnchor.constraint(equalToConstant: CGFloat.thinWidth).isActive = true
        @unknown default:
            borderView.heightAnchor.constraint(equalToConstant: CGFloat.thinWidth).isActive = true
        }

        return borderView
    }

    func addAction(_ action: AlertAction) {
        addArrangedSubview(makeBorderView())

        action.button.heightAnchor.constraint(equalToConstant: action.button.bounds.height).isActive = true
        addArrangedSubview(action.button)
    }

    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
