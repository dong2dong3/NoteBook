//
//  NoteModel.swift
//  NoteBook
//
//  Created by 张洁 on 2018/8/6.
//  Copyright © 2018年 张洁. All rights reserved.
//

import Foundation

class NoteModel: NSObject {
    var time: String?
    var title: String?
    var body: String?
    var group: String?
    var noteId: Int?
    func toDictionary() -> Dictionary<String,Any> {
        var dic: [String:Any] = ["time":time!, "title":title!, "body":body!, "ownGroup":group!]
        if let id = noteId {
            dic["noteId"] = id
        }
        return dic
    }
}
