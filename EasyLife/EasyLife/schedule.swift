//
//  schedule.swift
//  EasyLife
//
//  Created by 王昊泽 on 17/3/11.
//  Copyright © 2017年 Haoze Wang. All rights reserved.
//

import UIKit
import CoreData
class schedule: NSObject {
    
    static let scheduleInstance = schedule()
    
     func insertDate(schedule : Task){
        let moc = DataController().managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Task", into: moc) as! Task
        

        // add our data
        entity.setValue(schedule.date, forKey: "date")
        entity.setValue(schedule.title, forKey: "title")
        entity.setValue(schedule.begin, forKey: "begin")
        entity.setValue(schedule.desc, forKey: "desc")
        entity.setValue(schedule.end, forKey: "end")
        entity.setValue(schedule.fin_time, forKey: "fin_time")
        entity.setValue(schedule.ram_time, forKey: "ram_time")
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    
    func fetchDate(date : String) -> [Task]{
        let moc = DataController().managedObjectContext
        let TaskFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let predicate = NSPredicate(format:"date == %@", date)
        print(date)
        TaskFetch.predicate = predicate
        
        do {
            let fetchedTask = try moc.fetch(TaskFetch) as! [Task]
            return fetchedTask
            
        } catch {
            fatalError("Failed to fetch task: \(error)")
        }
    }
    
    
    func removeDate(id : Int64){
        let moc = DataController().managedObjectContext
        let TaskFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
       // let predicate = NSPredicate(format: "id = \(id)")
       // TaskFetch.predicate = predicate
       
        do{
            let fetchTask = try moc.fetch(TaskFetch) as! [Task]
            for i in fetchTask{
                moc.delete(i)
            }
            
        }catch{
            fatalError("Failed to move task: \(error)")

        }
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save task: \(error)")
        }

    }
    
}

func getstringfromdate_yy(date: Date) -> String{
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = "MM/dd/yy"
    
    let now = dateformatter.string(from: date)
    return now
}
