//
//  AppDelegate.swift
//  IntroSQLite
//
//  Created by Javier Rodríguez Gómez on 14/6/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Copiar bases de datos al directorio de la app
        copiarDBaDirectorio("buscadorAutos")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Esta función es para comprobar si la DB existe en el Bundle o en FileManager
    func copiarDBaDirectorio(_ nombreDB: String) {
        let objetoFileManager = FileManager.default
        let objetoFileHelper = FileHelper()
        let pathDBEnDocumentos = objetoFileHelper.pathArchivoEnCarpetaDocumentos(nombreArchivo: nombreDB)
        let pathDBEnBundle = objetoFileHelper.pathBaseDatosEnBundle(nombreBaseDatos: nombreDB)
        
        // Pasar el archivo de nuestra DB al path de carpeta de documentos
        if objetoFileHelper.existeArchivoEnDocumentos(nombreArchivo: nombreDB) {
            // Ya está la DB en Documentos
        } else {
            // No está la DB en Documentos
            do {
                try objetoFileManager.copyItem(atPath: pathDBEnBundle, toPath: pathDBEnDocumentos)
            } catch {
                print("Error al copiar el archivo al directorio")
            }
        }
    }
    
}

