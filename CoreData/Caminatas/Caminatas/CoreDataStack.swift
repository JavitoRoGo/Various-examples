//
//  CoreDataStack.swift
//  Caminatas
//
//  Created by Javier Rodríguez Gómez on 13/6/22.
//

import CoreData
import Foundation


class CoreDataStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Ocurrió un error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        self.storeContainer.viewContext
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Ocurrió un error: \(error.localizedDescription)")
        }
    }
}
