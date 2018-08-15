//
//  DataManager.swift
//  NoteBook
//
//  Created by 张洁 on 2018/8/5.
//  Copyright © 2018年 张洁. All rights reserved.
//
import SQLite
import Foundation
import CoreData
class DataManager: NSObject {
    static var db:OpaquePointer? = nil
    static var isOpen = false
    static var id: Int32 = 0
    static let createTableString = "CREATE TABLE NoteBook (Id INT PRIMARY KEY NOT NULL,GroupName CHAR(255));"
    static let insertStatementString = "INSERT INTO NoteBook (Id, GroupName) VALUES (?, ?);"

    class func saveGroup(name:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let groupEntity = NSEntityDescription.entity(forEntityName: "Group", in: context)
        let group = NSManagedObject(entity: groupEntity!, insertInto: context)
        group.setValue(name, forKey: "groupName")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    class func createTable() {
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("NoteBook table created.")
            } else {
                print("NoteBook table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    class func getGroupData() -> [String]{
        
        var groupName = [String]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let groupFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        let groupfe = try! context.fetch(groupFetch)

        groupfe.forEach { (item) in
            if let group = item as? Group {
                groupName.append(group.groupName!)
            }
        }
        return groupName
//        return query()
    }
    
    class func openDataBase() {
        let part1DbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        let file = part1DbPath + "/GroupName.sqlite"
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: file) {
            if sqlite3_open(file, &db) == SQLITE_OK {
                print("Successfully opened connection to database at \(part1DbPath)")
                isOpen = true
                createTable()
            } else {
                print("Unable to open database. Verify that you created the directory described " +
                    "in the Getting Started section.")
            }
            
        }
        if sqlite3_open(file, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(part1DbPath)")
            isOpen = true
        }
    }
    
    class func closeDB() {
        if sqlite3_close(db) == SQLITE_OK{
            db = nil
        }
    }
    static func insert(groupName:String) {
        if !isOpen {
            self.openDataBase()
        }
        var insertStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            id  = id + 1
            let name = groupName
            // 2
            sqlite3_bind_int(insertStatement, 1, id)
            // 3
            sqlite3_bind_text(insertStatement, 2, name, -1, nil)
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        }else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    class func addNote(note: NoteModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let noteDetailEntity = NSEntityDescription.entity(forEntityName: "NoteDetail", in: context)
        let noteDe = NSManagedObject(entity: noteDetailEntity!, insertInto: context)
        noteDe.setValue(note.title, forKey: "title")
        noteDe.setValue(note.time, forKey: "time")
        noteDe.setValue(note.body, forKey: "body")
        noteDe.setValue(note.group, forKey: "group")
        noteDe.setValue(note.noteId, forKey: "noteId")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    class func getNote(group: String) -> [NoteModel]  {

        var notes = [NoteModel]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let notesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteDetail")
        let notesFe = try! context.fetch(notesFetch)
        
        for item in notesFe {
            let noteM = NoteModel()
            
            if let fenote = item as? NoteDetail {
                noteM.time = fenote.time
                noteM.title = fenote.title
                noteM.body = fenote.body
                noteM.group = fenote.group
                noteM.noteId = Int(fenote.noteId)
                if noteM.group == group {
                    notes.append(noteM)
                }
            }
        }

        return notes
//        return array
    }
    
    class func updateNote(note: NoteModel) {

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let noteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteDetail")
        noteFetch.predicate = NSPredicate(format: "title = %@", "\(String(describing: note.title!))")
        let notesFe = try! context.fetch(noteFetch)
        if notesFe.count > 0 {
            if let fenote = notesFe.first as? NoteDetail {
                fenote.body = note.body
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func deleteNote(note: NoteModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let noteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteDetail")
        noteFetch.predicate = NSPredicate(format: "title = %@", "\(String(describing: note.title!))")
        let notesFe = try! context.fetch(noteFetch)
        if notesFe.count > 0 {
            context.delete(notesFe.first as! NSManagedObject)
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }    }
    
    class func delteGroup(name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let noteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteDetail")
        noteFetch.predicate = NSPredicate(format: "group = %@", "\(String(describing: name))")
        let notesFe = try! context.fetch(noteFetch)
        if notesFe.count > 0 {
            notesFe.forEach { (item) in
                context.delete(item as! NSManagedObject)
            }
        }
        
        let groupFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        groupFetch.predicate = NSPredicate(format: "groupName = %@", "\(String(describing: name))")
        let groupFe = try! context.fetch(groupFetch)
        if groupFe.count > 0 {
            groupFe.forEach { (item) in
                context.delete(item as! NSManagedObject)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func createNoteTable(){
        
    }
    
    static let queryStatementString = "SELECT * FROM NoteBook;"
    static func query() -> [String]{
        var queryStatement: OpaquePointer? = nil
        var groupNames : [String] = []
        if !isOpen {
            self.openDataBase()
        }
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                // 3
                let id = sqlite3_column_int(queryStatement, 0)
                
                // 4
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                
                // 5
                print("Query Result:")
                print("\(id) | \(name)")
                groupNames.append(name)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        return groupNames
    }
}
