//
//  Button.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/21.
//

import Foundation
import UIKit

extension UIButton {

    func switchAction(onAction: @escaping ()->Void, offAction: @escaping ()->Void) {
        //選択状態を反転
        self.isSelected = !self.isSelected

        switch self.isSelected {
        case true:
            //ONにする時に走らせたい処理
            onAction()
        case false:
            //OFFにする時に走らせたい処理
            offAction()
        }
    }
}
