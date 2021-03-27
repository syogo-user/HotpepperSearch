//
//  SearchTextField.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/23.
//

import Foundation
import UIKit
class SearchTextField:UITextField{
    //入力したテキストの余白
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20.0, dy: 0.0)
    }
    //編集中のテキストの余白
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20.0, dy: 0.0)
    }

    //プレースホルダーの余白
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20.0, dy: 0.0)
    }
    
}
