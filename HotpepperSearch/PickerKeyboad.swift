//
//  PickerKeyboad.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/24.
//
//
//import Foundation
//import UIKit
//class PickerKeyboad:UIControl{
//    private var textStore :String = ""
//
//    required init?(coder: NSCoder) {
//        super.init(coder:coder)
//        addTarget(self, action: #selector(didTap(_:)), for: .touchDown)
//    }
//    @objc func didTap(_ sennder:PickerKeyboad){
//        becomeFirstResponder()
//    }
//    override var canBecomeFirstResponder: Bool {return true}
//}
//
//extension PickerKeyboad:UIKeyInput {
//    //入力されたテキストが存在するか
//    var hasText: Bool {
//        return !textStore.isEmpty
//    }
//
//    //テキストが入力されたときに呼ばれる
//    func insertText(_ text: String) {
//        textStore += text
//        setNeedsDisplay()
//    }
//    //バックスペースが入力されたときに呼ばれる
//    func deleteBackward() {
//        textStore.remove(at: textStore.endIndex)
//
//
//    }
//
//
//}
