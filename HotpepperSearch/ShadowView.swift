//
//  ShadowView.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/20.
//

import Foundation
import UIKit
class ShadowView :UIView{
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    private func setupShadow() {
        self.layer.borderWidth = 0.2
        self.layer.cornerRadius = 25
        self.layer.shadowOffset = CGSize(width: 5, height: 5)//影の方向　右下
        self.layer.shadowRadius = 2// 影のぼかし量
        self.layer.shadowOpacity =  0.2 // 影の濃さ
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 25).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
