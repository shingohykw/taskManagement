//
//  InputTaskViewController.swift
//  taskManagement
//
//  Created by シンゴ on 2021/09/23.
//
//タスク入力画面PGM
//ファイルはCocoa touch classで作成

import UIKit

class InputTaskViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Text Fieldのdelegate通知先を設定
        titleText.delegate = self       //タイトル
        contentText.delegate = self     //内容
        categoryText.delegate = self    //カテゴリー
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //日付設定ピッカー
    @IBOutlet weak var dateSettingPicker: UIDatePicker!
    
    //タイトル入力フィールド
    @IBOutlet weak var titleText: UITextField!
    
    //内容入力フィールド
    @IBOutlet weak var contentText: UITextField!
    
    //カテゴリー入力フィールド
    @IBOutlet weak var categoryText: UITextField!
    
    //テキストフィールドを入力したときに実行（タイトル、内容、カテゴリー）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる
        textField.resignFirstResponder()
        
        //入力されたタイトルをデバッグエリアに表示
        if let inputedText = textField.text {
            print(inputedText)
        }
        
        return true
    }
    
    
}
