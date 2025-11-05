//
//  Alarmy+CoreDataProperties.swift
//  Alarmy
//
//  Created by jyeee on 11/4/25.
//
//

public import Foundation
public import CoreData


public typealias AlarmCoreDataPropertiesSet = NSSet

extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var date: Date?
    @NSManaged public var repeatDays: [Int]?
    @NSManaged public var alarmLabel: String?

}

extension Alarm : Identifiable {

}
