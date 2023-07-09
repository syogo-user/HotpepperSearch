//
//  ShadowView.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/20.
//

import Foundation
import UIKit

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        layer.borderWidth = 0.2
        layer.cornerRadius = 25
        layer.shadowOffset = CGSize(width: 5, height: 5)//影の方向　右下
        layer.shadowRadius = 2
        layer.shadowOpacity =  0.2
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 25).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
