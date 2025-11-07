import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private let worldClockEntity = "Alarm"
    
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
        } catch {
            print("전체 삭제 실패")
        }
    }
}

// 세계 시간 관련 함수 추가
extension CoreDataManager {
    
    func saveWorldData(city: (cityName: String, countryName: String, timeZoneID: String)) {
        let context = persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: worldClockEntity, in: context) else { return }
        let newClock = NSManagedObject(entity: entity, insertInto: context)
        
        newClock.setValue(city.timeZoneID, forKey: "timeZoneID")
        newClock.setValue(city.cityName, forKey: "cityName")
            
        do {
            try context.save()
        } catch {
        }
    }
    func loadWorldData() -> [(cityName: String, countryName: String, timeZoneID: String)] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: worldClockEntity)
        do {
            let result = try context.fetch(fetchRequest)
            return result.compactMap { obj in
                guard let id = obj.value(forKey: "timeZoneID") as? String,
                      let city = obj.value(forKey: "cityName") as? String else { return nil }
                return (cityName: city, countryName: "", timeZoneID: id)
            }
        } catch {
            return []
        }
    }
    func deleteAllWorldData() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: worldClockEntity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
        }
    }
    func deleteWorldData(with timeZoneID: String){
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: worldClockEntity)

        fetchRequest.predicate = NSPredicate(format: "timeZoneID == %@", timeZoneID)
        do {
            let result = try context.fetch(fetchRequest)
            for object in result {
                context.delete(object as! NSManagedObject)
            }
            try context.save()
        } catch {
        }
    }
}
