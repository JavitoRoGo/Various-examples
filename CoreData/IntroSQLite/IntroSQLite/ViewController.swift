//
//  ViewController.swift
//  IntroSQLite
//
//  Created by Javier Rodríguez Gómez on 14/6/22.
//

import UIKit

class ViewController: UIViewController {
    
    let objetoFileHelper = FileHelper()
    var miBaseDatos: FMDatabase? = nil
    var alert: UIAlertController? = nil
    
    @IBOutlet weak var guardarModelo: UITextField!
    @IBOutlet weak var precio: UITextField!
    @IBOutlet weak var buscarModelo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        miBaseDatos = FMDatabase(path: objetoFileHelper.pathArchivoEnCarpetaDocumentos(nombreArchivo: "buscadorAutos"))
    }
    
    @IBAction func guardar(_ sender: Any) {
        if guardarModelo.hasText && precio.hasText {
            iniciarGuardado(modelo: guardarModelo.text!, precio: Int(precio.text!)!)
        } else {
            // no se puede guardar
        }
    }
    
    @IBAction func buscar(_ sender: Any) {
        if buscarModelo.hasText {
            iniciarBusqueda(modelo: buscarModelo.text!)
        }
    }
    
    func iniciarGuardado(modelo: String, precio: Int) {
        if miBaseDatos!.open() {
            let foreignKey = "PRAGMA foreign_keys = ON"
            miBaseDatos!.executeUpdate(foreignKey, withArgumentsIn: [])
            // lo anterior es para corregir algo de las foreignkeys o llaves foráneas, pero no sé lo que es
            
            let insertQuerySQL = "INSERT INTO información (modelo, precio) VALUES ('\(modelo)','\(precio)')"
            let resultadoUpdate = miBaseDatos!.executeUpdate(insertQuerySQL, withArgumentsIn: [])
            if resultadoUpdate {
                print("Se agregó un registro a la tabla")
                alert = UIAlertController(title: "Listo", message: "Se agregó un registro a la tabla", preferredStyle: .alert)
                alert?.addAction(UIAlertAction(title: "Continuar", style: .cancel))
                present(alert!, animated: true)
            } else {
                print("Error al insertar datos: \(miBaseDatos!.lastErrorMessage())")
            }
        } else {
            print(("No se pudo abrir DB"))
        }
    }
    
    func iniciarBusqueda(modelo: String) {
        var precio: Int32?
        
        // Paso 1: abrir DB
        if miBaseDatos!.open() {
            // Paso 2: crear query SQL
            let querySQl = "SELECT precio FROM información WHERE modelo = '"+modelo+"'"
            
            // Paso 3: crear variable con resultados y ejecutar sentencia query
            let resultados: FMResultSet? = miBaseDatos!.executeQuery(querySQl, withParameterDictionary: nil)
            
            // Paso 4: iterar entre los resultados y asignar dato de precio a una variable
            while resultados!.next() == true {
                precio = resultados!.int(forColumn: "precio")
            }
            
            // Paso 5: cerrar DB y mostrar resultado en alerta
            miBaseDatos!.close()
            alert = UIAlertController(title: "Listo", message: "El precio es \(precio!)", preferredStyle: .alert)
            alert?.addAction(UIAlertAction(title: "Continuar", style: .cancel))
            present(alert!, animated: true)
            
        } else {
            print(("No se pudo abrir DB"))
        }
    }
}

