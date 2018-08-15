//
//  ViewController.swift
//  NoteBook
//
//  Created by 张洁 on 2018/8/5.
//  Copyright © 2018年 张洁. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    var homeView: HomeView?
    var dataArray: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "阿不斯是个小可爱啊!"
        dataArray = DataManager.getGroupData()
        //取消导航栏对页面布局的影响
        edgesForExtendedLayout = UIRectEdge()
        installUI()
        installNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataArray = DataManager.getGroupData()
        self.homeView?.dataArray = dataArray
        self.homeView?.updateLayout()
    }
    
    func installUI() {
        homeView = HomeView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-64))
        view.addSubview(homeView!)
        homeView?.homeButtonDelegate = self
        homeView?.dataArray = dataArray
        homeView?.updateLayout()
    }
    
    func installNavigationItem(){
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func addGroup() {
        let alertController = UIAlertController(title: "添加记事分组", message: "添加的分组名不能和已有分组重复或为空", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "请输入记事分组名称"
        }
        let alertItem = UIAlertAction(title: "取消", style: .cancel) { (action) in
            return
        }
        
        let alertItemAdd = UIAlertAction(title: "确定", style: .default) { (action) in
            //进行有效判断
            var exist = false
            
            self.dataArray?.forEach({ (element) in
                if element == alertController.textFields?.first!.text || alertController.textFields?.first!.text?.characters.count == 0 {
                    exist = true
                }
            })
            if exist {
                return
            }
            self.dataArray?.append(alertController.textFields!.first!.text!)
            self.homeView?.dataArray = self.dataArray
            self.homeView?.updateLayout()
            DataManager.saveGroup(name: alertController.textFields!.first!.text!)
            
        }
        alertController.addAction(alertItem)
        alertController.addAction(alertItemAdd)
        present(alertController, animated: true, completion: nil)
    }
}

extension  ViewController: HomeButtonDelegate {
    func homeButtonClick(title: String) {
        let controller = NoteListTableViewController()
        controller.name = title
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

