//
//  TextField.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/24.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

final class TextField: UITextField {
    var handler: ((UITextField) -> Void)?

    init() {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 14)
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = CGFloat.thinWidth
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 4, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 4, dy: 0)
    }
}
