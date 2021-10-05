//
//  ViewController.swift
//  taskManagement
//
//  Created by シンゴ on 2021/09/22.
//
//タスク一覧画面

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Realmから受け取るデータを入れる変数を準備
    var taskList = try! Realm().objects(TaskDB.self)
    //タスク一覧紐付け
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    //viewWillAppearは遷移されるたびに実行されるのでここでtableViewを再読み込みする。
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    //タップした行を更新
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タップしたセルの行番号を出力
        print("\(indexPath.row)番目の行が選択されました")
        //タップしたセルのデータを取得して詳細画面へ遷移するようにする。
        let cell = self.tableView.cellForRow(at: indexPath) as! TaskListCell
        print(String(describing: cell.cellTitle.text))
        //タップしたセルのtaskIDを取得
        let taskID = taskList[indexPath.row].taskID
        print(String(describing: taskID))
        
        //タスク詳細画面に遷移。引数にtaskIDを指定
        performSegue(withIdentifier: "goTaskInput", sender: taskID)
    }
    
    //prepareは画面遷移前に実行される。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //タスク入力画面に遷移する場合はtaskID(sender)をタスク入力画面へ渡す。
        if segue.identifier == "goTaskInput" {
            let inputTaskViewController = segue.destination as! InputTaskViewController
            //タスク新規作成時はtaskIDないのでif let使う
            if let taskID = sender {
                inputTaskViewController.taskDB.taskID = taskID as! Int
            }
            
        }
    }
    
//タスク入力画面へ遷移
    @IBAction func inputTaskButtonAction(_ sender: Any) {
        //画面遷移を行う(データ渡すときにnilを変更する。）
        performSegue(withIdentifier: "goTaskInput", sender: nil)
    }
    //タスク一覧の行数取得
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    //各セルを生成して返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの再利用を行う。
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskListCell
        
        let task = taskList[indexPath.row]
        
        cell.cellTitle.text = task.title
        cell.cellContent.text = task.content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        cell.cellDate.text = dateFormatter.string(from: task.date)
        
        return cell
    }
    
    
}

