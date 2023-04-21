//
//  Person+CoreDataProperties.swift
//  Caminatas
//
//  Created by Javier Rodríguez Gómez on 14/6/22.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var caminatas: NSOrderedSet?

}

// MARK: Generated accessors for caminatas
extension Person {

    @objc(insertObject:inCaminatasAtIndex:)
    @NSManaged public func insertIntoCaminatas(_ value: CadaCaminata, at idx: Int)

    @objc(removeObjectFromCaminatasAtIndex:)
    @NSManaged public func removeFromCaminatas(at idx: Int)

    @objc(insertCaminatas:atIndexes:)
    @NSManaged public func insertIntoCaminatas(_ values: [CadaCaminata], at indexes: NSIndexSet)

    @objc(removeCaminatasAtIndexes:)
    @NSManaged public func removeFromCaminatas(at indexes: NSIndexSet)

    @objc(replaceObjectInCaminatasAtIndex:withObject:)
    @NSManaged public func replaceCaminatas(at idx: Int, with value: CadaCaminata)

    @objc(replaceCaminatasAtIndexes:withCaminatas:)
    @NSManaged public func replaceCaminatas(at indexes: NSIndexSet, with values: [CadaCaminata])

    @objc(addCaminatasObject:)
    @NSManaged public func addToCaminatas(_ value: CadaCaminata)

    @objc(removeCaminatasObject:)
    @NSManaged public func removeFromCaminatas(_ value: CadaCaminata)

    @objc(addCaminatas:)
    @NSManaged public func addToCaminatas(_ values: NSOrderedSet)

    @objc(removeCaminatas:)
    @NSManaged public func removeFromCaminatas(_ values: NSOrderedSet)

}

extension Person : Identifiable {

}
