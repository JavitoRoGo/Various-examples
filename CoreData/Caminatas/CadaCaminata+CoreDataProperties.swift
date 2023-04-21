//
//  CadaCaminata+CoreDataProperties.swift
//  Caminatas
//
//  Created by Javier Rodríguez Gómez on 14/6/22.
//
//

import Foundation
import CoreData


extension CadaCaminata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CadaCaminata> {
        return NSFetchRequest<CadaCaminata>(entityName: "CadaCaminata")
    }

    @NSManaged public var date: Date?
    @NSManaged public var persona: Person?

}

extension CadaCaminata : Identifiable {

}
