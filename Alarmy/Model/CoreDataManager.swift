//
//  CoreDataManager.swift
//  Alarmy
//
//  Created by jyeee on 11/4/25.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Alarmy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createData(date: Date, alarmLabel: String, repeatDays: [Int]) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: self.persistentContainer.viewContext) else { return }
        
        let newAlarm = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        
        newAlarm.setValue(date, forKey: "date")
        newAlarm.setValue(alarmLabel, forKey: "alarmLabel")
        newAlarm.setValue(repeatDays, forKey: "repeatDays")
        
        do {
            try self.persistentContainer.viewContext.save()
            print("저장 성공")
        } catch {
            print("저장 실패")
        }
    }
}
