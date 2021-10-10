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
    let taskDB: TaskDB = TaskDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Text Fieldのdelegate通知先を設定 (後でキーボードを下げるときに利用するため）
        titleText.delegate = self       //タイトル
        contentText.delegate = self     //内容
        categoryText.delegate = self    //カテゴリー
        
        //テキストボックス以外の場所をタップしたときにキーボードを閉じる。
        setDismissKeyboard()
        
        //タスク一覧画面で選んだセルのタスクIDを取得
        let taskID: Int = taskDB.taskID
        
        if taskID != 0 {
            //RealmからタスクIDで一致するレコードを取得。
            let selectedData = realm.objects(TaskDB.self).filter("taskID == %@", taskID)
            print(selectedData)
            //取得したレコードを画面へ反映
            dateSettingPicker.date = selectedData[0].date
            titleText.text = selectedData[0].title
            contentText.text = selectedData[0].content
            categoryText.text = selectedData[0].category
        }
    }

    //保存ボタン押下時アクション
    @IBAction func saveTaskButtonAction(_ sender: Any) {
        
        let taskID: Int = taskDB.taskID
        
        //タスク日付取得
        let date: Date = dateSettingPicker.date
            print(date)
            taskDB.date = date
        
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
        
        //タスク新規作成時はタスクIDを新規採番する。
        if taskID == 0 {
            //データ数取得
            let dataCount = realm.objects(TaskDB.self).count
            
            if dataCount == 0 {
             //データ件数０で新規タスク作成の場合
                taskDB.taskID = 1
                
            } else {
            //最新のタスクID取得(データ件数が０のときlatestTaskがnilになって実行時エラーになるのを防ぐ）
            let latestTask: TaskDB = realm.objects(TaskDB.self).sorted(byKeyPath: "taskID", ascending: false).first!
            //新規タスクID採番（最新＋１）
            taskDB.taskID += latestTask.taskID + 1
            }
        }
        
        //Realmにデータを追加、更新（同じIDがあるときは更新する。）
        try! realm.write {
            realm.add(taskDB, update: .modified)
        }
        //前画面に戻る
        _ = navigationController?.popViewController(animated: true)
    }
    
    //タスク一覧の行数取得　（UITableViewDelegate, UITableViewDataSourceをクラスに指定しなくても良いのはなぜか？？？？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(TaskDB.self).count
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
