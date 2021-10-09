//
//  InputTaskViewControllerDismissKeyboard.swift
//  taskManagement
//
//  Created by シンゴ on 2021/10/09.
//
//タスク入力画面でテキストボックス以外の場所をタップしたときにキーボードを閉じる。


import UIKit

extension InputTaskViewController {
    func setDismissKeyboard() {
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
