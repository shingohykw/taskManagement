//
//  ViewController.swift
//  taskManagement
//
//  Created by シンゴ on 2021/09/22.
//
//タスク一覧画面

import UIKit
import RealmSwift

class ViewController: UIViewController {

    //タスク一覧紐付け
    @IBOutlet weak var taskTable: UITableView!
    
    //Realmから受け取るデータを入れる変数を準備
    var taskList: Results<taskDB>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Realmのインスタンスを取得
        let realm = try! Realm()
        taskList = realm.objects(taskDB.self)
        taskTable.reloadData()
        
    }
    
    
//タスク入力画面へ遷移
    @IBAction func inputTaskButtonAction(_ sender: Any) {
        //画面遷移を行う(データ渡すときにnilを変更する。）
        performSegue(withIdentifier: "goTaskInput", sender: nil)
    }

}



extension ViewController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskListCell
        
        let task = taskList[indexPath.row]
        
        cell.cellTitle.text = task.title
        
        return cell
    }
    
}



