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
    
    //Realmデータベースを取得
    let realm = try! Realm()
    //モデルクラス（taskDB)をインスタンス化
    let taskDB: TaskDB = TaskDB()  //????
    
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
     
            
        //タスク日付取得
        let date: Date = dateSettingPicker.date
            print(date)
            taskDB.date = date
//        //タスクタイトル取得 エラー
//        let title: String = titleText.text
//            print(title)
//            taskDBInstance.title = title
        
        //タスクタイトル取得
        if let title = titleText.text {
            print(title)
            taskDB.title = title
        }
        //タスク内容取得
        if let content = contentText.text {
            print(content)
            taskDB.content = content
        }
        //カテゴリー取得
        if let category = categoryText.text {
            print(category)
            taskDB.category = category
        }
        
       
        
        //Realmにデータを追加
        try! realm.write {
            realm.add(taskDB)
        }
        
        //前画面に戻る
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    
    
    
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
    

    
}
