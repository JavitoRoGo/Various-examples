//
//  AppDelegate.swift
//  Caminatas
//
//  Created by Javier Rodríguez Gómez on 12/6/22.
//

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack(modelName: "caminatas")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Definir nuestro modelo de guardado de datos
        guard let navController = window?.rootViewController as? UINavigationController,
              let viewController = navController.topViewController as? ViewController else { return true }
        viewController.managedContext = coreDataStack.managedContext
        
        return true
    }
    
    // Las siguientes dos funciones son para que se guarden los datos automáticamente al cerrar la app
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}

