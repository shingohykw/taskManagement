//
//  ViewController.swift
//  taskManagement
//
//  Created by シンゴ on 2021/09/22.
//
//タスク一覧画面

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    //Realmから受け取るデータを入れる変数を準備
    var realm = try! Realm()
    //var sortedRealm = try! Realm().objects(TaskDB.self)
    var searchWord: String? = ""
    
//    //検索バーのテキスト格納用変数
//    var searchWord: String?
    
    //タスク一覧紐付け
    @IBOutlet weak var tableView: UITableView!
    //タスク入力画面へ遷移
    @IBAction func inputTaskButtonAction(_ sender: Any) {
        //タスク新規作成時はtaskID = 0。
        let taskID: Int = 0
        //画面遷移を行う(データ渡すときにnilを変更する。）
        performSegue(withIdentifier: "goTaskInput", sender: taskID)
    }
    //検索バー
    @IBOutlet weak var searchText: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchText.delegate = self
        searchText.placeholder = "カテゴリーを入力してください"
    }
    
    //viewWillAppearは遷移されるたびに実行されるのでここでtableViewを再読み込みする。
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    //タップした行を更新
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //キーボードを閉じる（検索バー触るとキーボードが出てる状態になるため）
        view.endEditing(true)
        //タップしたセルの行番号を出力
        print("\(indexPath.row)番目の行が選択されました")
        
        //タスクの並び替え、フィルター
        let sortedRealm: Results<TaskDB> = sortedList(keyword: searchWord)
        let taskID = sortedRealm[indexPath.row].taskID
        print(String(describing: taskID))
        
        //タスク詳細画面に遷移。引数にtaskIDを指定
        performSegue(withIdentifier: "goTaskInput", sender: taskID)
    }
    
    //prepareは画面遷移前に実行される。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //タスク入力画面に遷移する場合はtaskID(sender)をタスク入力画面へ渡す。
        if segue.identifier == "goTaskInput" {
            let inputTaskViewController = segue.destination as! InputTaskViewController
            
            if let taskID = sender {
                inputTaskViewController.taskDB.taskID = taskID as! Int
            }
        }
    }
    

    
    //タスク一覧の行数取得
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var realmCount: Int
        //検索の有無によって行数調整
        if searchWord == "" {
            realmCount = realm.objects(TaskDB.self).count
        } else {
            realmCount = realm.objects(TaskDB.self).filter("category = %@", searchWord!).sorted(byKeyPath: "date", ascending: true).count
        }
        return realmCount
    }
    
    //各セルを生成して返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの再利用を行う。
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskListCell
        //タスクの並び替え、フィルター
        let sortedRealm: Results<TaskDB> = sortedList(keyword: searchWord)
        
        let task = sortedRealm[indexPath.row]
        
        cell.cellTitle.text = task.title
        cell.cellContent.text = task.content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        cell.cellDate.text = dateFormatter.string(from: task.date)
        
        return cell
    }
    
    //検索ボタンをクリックしたとき実行
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //キーボードを閉じる
        view.endEditing(true)
        searchWord = searchBar.text
        self.tableView.reloadData()
    }
    
    //タスク一覧の並び替えとカテゴリーフィルター機能
    func sortedList(keyword: String?) -> Results<TaskDB> {
        var sortedRealm = realm.objects(TaskDB.self)
        //セル並び替え判断：日付順 or 日付＋カテゴリー抽出
        if searchWord == "" {
            sortedRealm = realm.objects(TaskDB.self).sorted(byKeyPath: "date", ascending: true)
        } else {
            sortedRealm = realm.objects(TaskDB.self).filter("category = %@", searchWord!).sorted(byKeyPath: "date", ascending: true)
        }
        return sortedRealm
    }
    
    //セルを右から左へスワイプしたときに削除ボタンを表示させ、タップすると削除する。
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") {(action, view, completionHandler) in
            //削除処理を記述
            do {
                //タスクの並び替え、フィルター
                let sortedRealm: Results<TaskDB> = self.sortedList(keyword: self.searchWord)
                let task: TaskDB = sortedRealm[indexPath.row]
                
                try self.realm.write{
                    self.realm.delete(task)
                }
            } catch {
                return
            }
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            completionHandler(true)
        }
        //削除ボタンは赤色
        deleteAction.backgroundColor = UIColor.red
        //定義したアクション（削除）をセット
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
}

