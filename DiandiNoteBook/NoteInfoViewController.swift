//
//  NoteInfoViewController.swift
//  NoteBook
//
//  Created by 张洁 on 2018/8/13.
//  Copyright © 2018年 张洁. All rights reserved.
//

import UIKit
import SnapKit
class NoteInfoViewController: UIViewController {

    var noteModel: NoteModel?
    var titleTextField: UITextField?
    
    var bodyTextView : UITextView?
    
    var group: String?
    var isNew = false

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = group!
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardBeShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        installUI()
        installNavigationItem()
    }

    func installNavigationItem() {
        let itemSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addNote))
        let itemDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        self.navigationItem.rightBarButtonItems = [itemSave, itemDelete]
    }
    func installUI() {
        titleTextField = UITextField()
        self.view.addSubview(titleTextField!)
        titleTextField?.borderStyle = .none
        titleTextField?.placeholder = "请输入记事本标题"
        titleTextField?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(30)
            maker.left.equalTo(30)
            maker.right.equalTo(-30)
            maker.height.equalTo(30)
        })
        let line = UIView()
        self.view.addSubview(line)
        line.backgroundColor = UIColor.gray
        line.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.top.equalTo(titleTextField!.snp.bottom).offset(5)
            maker.right.equalTo(-15)
            maker.height.equalTo(0.5)
        }
        bodyTextView = UITextView()
        bodyTextView?.layer.borderColor = UIColor.gray.cgColor
        bodyTextView?.layer.borderWidth = 0.5
        self.view.addSubview(bodyTextView!)
        bodyTextView?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(line.snp.bottom).offset(10)
            maker.left.equalTo(30)
            maker.right.equalTo(-30)
            maker.bottom.equalTo(-30)
        })
        if !isNew {
            titleTextField?.text = noteModel?.title
            bodyTextView?.text = noteModel?.body
        }
    }
    @objc func keyBoardBeShow(notification: Notification){
        let userInfo = notification.userInfo!
        let frameInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject
        let height = frameInfo.cgRectValue.size.height
        bodyTextView?.snp.updateConstraints({ (maker) in
            maker.bottom.equalTo(-30-height)
        })
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        
        
    }
    @objc func keyBoardBeHidden(notification: Notification){
        bodyTextView?.snp.updateConstraints({ (maker) in
            maker.bottom.equalTo(-30)
        })
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func addNote() {
        if isNew {
            if titleTextField?.text != nil && titleTextField!.text!.characters.count > 0 {
                noteModel = NoteModel()
                noteModel?.title = titleTextField?.text!
                noteModel?.body = bodyTextView?.text
                noteModel?.group = group
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFormatter.string(from: Date())
                DataManager.addNote(note: noteModel!)
                self.navigationController?.popViewController(animated: true)
                
            }
        } else {
            if titleTextField?.text != nil && titleTextField!.text!.characters.count > 0 {
                noteModel = NoteModel()
                noteModel?.title = titleTextField?.text!
                noteModel?.body = bodyTextView?.text
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFormatter.string(from: Date())
                DataManager.updateNote(note: noteModel!)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @objc func deleteNote() {
        let alertController = UIAlertController(title: "警告", message: "您确定要删除这个记录吗?", preferredStyle: .alert)
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "删除", style: .destructive) { (action) in
            if !self.isNew {
                DataManager.deleteNote(note: self.noteModel!)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        alertController.addAction(action)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bodyTextView?.resignFirstResponder()
        titleTextField?.resignFirstResponder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
