//
//  ViewController.swift
//  taskManagement
//
//  Created by シンゴ on 2021/09/22.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
//タスク入力画面へ遷移
    @IBAction func inputTaskButtonAction(_ sender: Any) {
        
        //画面遷移を行う(データ渡すときにnilを変更する。）
        performSegue(withIdentifier: "goTaskInput", sender: nil)
    }
    
}

