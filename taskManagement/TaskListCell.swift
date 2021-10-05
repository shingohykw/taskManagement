//
//  TaskListCell.swift
//  taskManagement
//
//  Created by シンゴ on 2021/09/25.
//
//tableViewのセル表示用

import UIKit

class TaskListCell: UITableViewCell {
    //セルのタスク日付
    @IBOutlet weak var cellDate: UILabel!
    //セルのタスクタイトル
    @IBOutlet weak var cellTitle: UILabel!
    //セルのタスク内容
    @IBOutlet weak var cellContent: UILabel!
    
}

