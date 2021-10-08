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
    //検索バーのテキスト格納用変数
    var searchWord: String?
    
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
 
        //タップしたセルのtaskIDを取得(日付順に並び替える）
        let taskID = realm.objects(TaskDB.self).sorted(byKeyPath: "date", ascending: true)[indexPath.row].taskID
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
        return realm.objects(TaskDB.self).count
    }
    //各セルを生成して返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの再利用を行う。
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskListCell
        //セルを日付順に並び替え
        let sortedRealm = realm.objects(TaskDB.self).sorted(byKeyPath: "date", ascending: true)
        let task = sortedRealm[indexPath.row]
        
        cell.cellTitle.text = task.title
        cell.cellContent.text = task.content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        cell.cellDate.text = dateFormatter.string(from: task.date)
        
        return cell
    }
    
    //セルを右から左へスワイプしたときに削除ボタンを表示させ、タップすると削除する。
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") {(action, view, completionHandler) in
            //削除処理を記述
            do {
                //タップしたセルのtaskを取得し削除
                let task: TaskDB = self.realm.objects(TaskDB.self)[indexPath.row]
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
    
    //検索ボタンをクリックしたとき実行
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる
        view.endEditing(true)
        searchWord = searchBar.text
        print(searchWord)
        
        //func tableviewを呼び出す？引数はsearchWord? override or extension ?
    }
    
    
}

