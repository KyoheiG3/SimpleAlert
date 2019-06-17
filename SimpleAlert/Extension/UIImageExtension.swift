//
//  UIImageExtension.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2019/06/15.
//  Copyright © 2019 kyohei_ito. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))

        defer {
            UIGraphicsEndImageContext()
        }

        guard let image = UIGraphicsGetImageFromCurrentImageContext(), let data = image.pngData() else { return nil }
        self.init(data: data, scale: image.scale)
    }
}
