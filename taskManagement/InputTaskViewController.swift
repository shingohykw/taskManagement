//
//  InputTaskViewController.swift
//  taskManagement
//
//  Created by シンゴ on 2021/09/23.
//
//タスク入力画面PGM
//ファイルはCocoa touch classで作成

import UIKit
import RealmSwift

class InputTaskViewController: UIViewController, UITextFieldDelegate {

    //タスク編集画面スクロールビュー（カテゴリーとか入力するときにキーボードで隠れないようにスクロールさせる。
    @IBOutlet weak var scrollViewTaskInput: UIScrollView!
    //日付設定ピッカー
    @IBOutlet weak var dateSettingPicker: UIDatePicker!
    //タイトル入力フィールド
    @IBOutlet weak var titleText: UITextField!
    //内容入力フィールド
    @IBOutlet weak var contentText: UITextField!
    //カテゴリー入力フィールド
    @IBOutlet weak var categoryText: UITextField!
    
    //アクティブなテキストフィールドを判断 ****テキストフィールドのスクロールで追加
    //var textActiveField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Text Fieldのdelegate通知先を設定 (後でキーボードを下げるときに利用するため）
        titleText.delegate = self       //タイトル
        contentText.delegate = self     //内容
        categoryText.delegate = self    //カテゴリー
        
       
        
    }

    //保存ボタン押下時アクション
    @IBAction func saveTaskButtonAction(_ sender: Any) {
        //モデルクラス（taskDB)をインスタンス化
        let taskDBInstance: taskDB = taskDB()  //????
                
        //タスク日付取得
        let date: Date = dateSettingPicker.date
            print(date)
            taskDBInstance.date = date
//        //タスクタイトル取得 エラー
//        let title: String = titleText.text
//            print(title)
//            taskDBInstance.title = title
        
        //タスクタイトル取得
        if let title = titleText.text {
            print(title)
            taskDBInstance.title = title
        }
        //タスク内容取得
        if let content = contentText.text {
            print(content)
            taskDBInstance.content = content
        }
        //カテゴリー取得
        if let category = categoryText.text {
            print(category)
            taskDBInstance.category = category
        }
        
        //Realmデータベースを取得
        let realm = try! Realm()
        
        //Realmにデータを追加
        try! realm.write {
            realm.add(taskDBInstance)
        }
        
        //前画面に戻る
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    //テキストフィールドが入力状態のときに実行 (** UITextField! でなくてもよい？） **テキストフィールドのスクロールで追加
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textActiveField = textField
//        return true
//    }
    
    //テキストフィールドに入力完了したときに実行（タイトル、内容、カテゴリー）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる
        textField.resignFirstResponder()
        
        //入力された文字をデバッグエリアに表示
        if let inputedText = textField.text {
            print(inputedText)
        }
        
        return true
    }
    
//    //キーボードがテキストフィールドに重ならないようにする
//    func handleKeyboardWillShowNotification(notification: NSNotification) {
//        let userInfo = notification.userInfo!
//        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let myBoundSize: CGSize = UIScreen.main.bounds.size
//
//        let textLimit = textActiveField.frame.origin.y + textActiveField.frame.height + 8.0
//        let keyboardLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
//
//        print("テキストフィールドの下辺：\(textLimit)")
//        print("キーボードの上辺：\(keyboardLimit)")
//
//        if textLimit >= keyboardLimit {
//            scrollViewTaskInput.contentOffset.y = textLimit - keyboardLimit
//        }
//    }
//
//    func handleKeyboardWillHideNotification(notification: NSNotification) {
//        scrollViewTaskInput.contentOffset.y = 0
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    
}
