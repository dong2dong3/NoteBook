//
//  NoteListTableViewController.swift
//  NoteBook
//
//  Created by 张洁 on 2018/8/6.
//  Copyright © 2018年 张洁. All rights reserved.
//

import UIKit

class NoteListTableViewController: UITableViewController {
    var dataArray = Array<NoteModel>()
    //当前分组
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        installNavigationItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataArray = DataManager.getNote(group: name!)
        tableView.reloadData()
    }
    
    func installNavigationItem(){
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleterGroup))
        navigationItem.rightBarButtonItems = [addItem, deleteItem]
    }
    
    @objc func addNote() {
        let infoVC = NoteInfoViewController()
        infoVC.group = name!
        infoVC.isNew = true
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    @objc func deleterGroup() {
        
        let alertController = UIAlertController(title: "警告", message: "您确定要删除此分组下的所有记事?", preferredStyle: .alert)
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "删除", style: .destructive) { (action) in
            DataManager.delteGroup(name: self.name!)
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let model = dataArray[indexPath.row]
        cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = model.time
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let infoVC = NoteInfoViewController()
        infoVC.group = name!
        infoVC.isNew = false
        infoVC.noteModel = dataArray[indexPath.row]
        self.navigationController?.pushViewController(infoVC, animated: true)
        
    }
}
