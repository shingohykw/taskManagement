//
//  Realm.swift
//  taskManagement
//
//  Created by シンゴ on 2021/09/25.
//
//タスクを保存するRealmデータベースを実装

import Foundation
import RealmSwift

//タスク項目定義
class TaskDB: Object {
    @objc dynamic var taskID: Int = 0           //タスクID
    @objc dynamic var date: Date = Date()       //日付
    @objc dynamic var title: String = ""        //タイトル
    @objc dynamic var content: String? = ""     //内容
    @objc dynamic var category: String? = ""    //カテゴリー
    
    //タスクIDをプライマリーキーに指定
    override static func primaryKey() -> String? {
        return "taskID"
    }
}
