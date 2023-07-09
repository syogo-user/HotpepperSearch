//
//  UIButton+Extention.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/21.
//

import Foundation
import UIKit

extension UIButton {
    func switchAction(onAction: @escaping ()->Void, offAction: @escaping ()->Void) {
        // 選択状態を反転
        self.isSelected = !self.isSelected

        switch self.isSelected {
        case true:
            // ON時
            onAction()
        case false:
            // OFF時
            offAction()
        }
    }
}
