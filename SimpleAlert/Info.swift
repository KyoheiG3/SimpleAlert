//
//  Info.swift
//  SimpleAlert
//
//  Created by Kyohei Ito on 2017/11/25.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

struct Info {
    private var userInfo: [AnyHashable: Any]?

    init(userInfo: [AnyHashable: Any]?) {
        self.userInfo = userInfo
    }

    var keyboardFrameEnd: CGRect? {
        return userInfoRect(UIResponder.keyboardFrameEndUserInfoKey)
    }

    var duration: TimeInterval? {
        return userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
    }

    var curve: UIView.AnimationOptions? {
        return (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt).map(UIView.AnimationOptions.init)
    }

    private func userInfoRect(_ infoKey: String) -> CGRect? {
        let frame = (userInfo?[infoKey] as? NSValue)?.cgRectValue
        if let rect = frame, rect.origin.x.isInfinite || rect.origin.y.isInfinite {
            return nil
        }
        return frame
    }
}

extension Notification {
    var info: Info {
        return Info(userInfo: userInfo)
    }
}
