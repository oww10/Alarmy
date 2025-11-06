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
    
    func createData(date: Date, alarmLabel: String, repeatDays: [Int], isOn: Bool = true) -> Alarm {
        let context = persistentContainer.viewContext
        let alarm = Alarm(context: context)
        alarm.date = date
        alarm.alarmLabel = alarmLabel
        alarm.repeatDays = repeatDays
        alarm.isOn = isOn

        do {
            try context.save()
            NotificationCenter.default.post(name: .init("alarmDidChange"), object: nil)
            print("저장 성공")
        } catch {
            print("저장 실패:", error)
        }
        
        return alarm
    }

    
    func readData() -> [Alarm] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Fetch error:", error)
            return []
        }
    }
    
    func deleteData(alarm: Alarm) {
        let context = persistentContainer.viewContext
        context.delete(alarm)
        do {
            try context.save()
            print("스와이프 삭제 성공")
        } catch {
            print("스와이프 삭제 실패")
        }
    }
    
    func deleteAllData() {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        do {
            let all = try context.fetch(request)
            all.forEach { context.delete($0) }
            try context.save()
            print("전체 삭제 성공")
        } catch {
            print("전체 삭제 실패")
        }
    }
}
