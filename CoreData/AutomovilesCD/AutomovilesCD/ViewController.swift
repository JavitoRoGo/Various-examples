//
//  ViewController.swift
//  AutomovilesCD
//
//  Created by Javier Rodríguez Gómez on 4/6/22.
//

import CoreData
import UIKit

class ViewController: UIViewController {
    
    // Creamos un contexto para poder guardar y recuperar los datos
    var managedContext: NSManagedObjectContext!
    
    var automovilActual: Automovil!
    
    // MARK: - Outlets
    
    @IBOutlet weak var fotoAuto: UIImageView!
    @IBOutlet weak var selectorAuto: UISegmentedControl!
    @IBOutlet weak var labelModelo: UILabel!
    @IBOutlet weak var labelCalif: UILabel!
    @IBOutlet weak var labelVecesProbado: UILabel!
    @IBOutlet weak var labelFechaPrueba: UILabel!
    
    
    // MARK: - UI View

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate!.persistentContainer.viewContext
        // las dos líneas anteriores son cosa mía para que funcione la app
        guardarDatosPlistEnCoreData()
        
        // Cargar los datos iniciales para el primer coche
        let peticion = NSFetchRequest<Automovil>(entityName: "Automovil")
        let primerTitulo = selectorAuto.titleForSegment(at: 0)!
        peticion.predicate = NSPredicate(format: "busqueda == %@", primerTitulo)
        //predicado: buscar todo lo que haya donde "busqueda" sea primerTitulo
        do {
            let resultados = try managedContext.fetch(peticion)
            automovilActual = resultados.first
            popularDatos(automovil: automovilActual)
        } catch {
            print("No puede recuperar datos: \(error)")
        }
    }
    
    func guardarDatosPlistEnCoreData() {
        // Función para comprobar si ya están los datos de plist en CD, para no guardarlos cada vez que se inicia la app
        let peticion = NSFetchRequest<Automovil>(entityName: "Automovil")
        peticion.predicate = NSPredicate(format: "nombre != nil")
        
        let cantidad = try! managedContext.count(for: peticion)
        
        if cantidad > 0 {
            // ya hay datos en CD
            print("CoreData ya tiene la información inicial del plist")
            return
        } else {
            // no hay datos en CD
            print("Se guardarán los datos iniciales que están en plist")
            let pathPlist = Bundle.main.path(forResource: "ListaDatosIniciales", ofType: "plist")!
            let arregloDatosPlist = NSArray(contentsOfFile: pathPlist)!
            for diccionarioDatosPlist in arregloDatosPlist {
                // pasamos los datos a diccionario porque cada valor en plist está definido como diccionario
                let entity = NSEntityDescription.entity(forEntityName: "Automovil", in: managedContext)!
                let automovil = Automovil(entity: entity, insertInto: managedContext)
                let dicAutomovil = diccionarioDatosPlist as! [String: AnyObject]
                
                automovil.nombre = dicAutomovil["nombre"] as? String
                automovil.busqueda = dicAutomovil["busqueda"] as? String
                automovil.calificacion = dicAutomovil["calificacion"] as! Double
                
                let nombreArchivo = dicAutomovil["nombreImagen"] as? String
                let imagen = UIImage(named: nombreArchivo!)
                let datosArchivoImg = imagen!.jpegData(compressionQuality: 0.5)
                automovil.datosImagen = datosArchivoImg
                
                automovil.ultimaPrueba = dicAutomovil["ultimaPrueba"] as? Date
                
                let vecesProbado = dicAutomovil["vecesProbado"] as! NSNumber
                automovil.vecesProbado = vecesProbado.int32Value
                
                try! managedContext.save()
            }
        }
    }
    
    func popularDatos(automovil: Automovil) {
        guard let datosImagen = automovil.datosImagen,
              let ultimaPrueba = automovil.ultimaPrueba else { return }
        
        fotoAuto.image = UIImage(data: datosImagen)
        
        let formatoFecha = DateFormatter()
        formatoFecha.dateStyle = .short
        formatoFecha.timeStyle = .none
        labelFechaPrueba.text = "Última prueba: " + formatoFecha.string(from: ultimaPrueba)
        
        labelModelo.text = automovil.nombre
        labelCalif.text = "Calificación: \(automovil.calificacion)"
        labelVecesProbado.text = "Veces probado: \(automovil.vecesProbado)"
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func selectorAutoAction(_ sender: Any) {
        guard let selectorAutomovil = sender as? UISegmentedControl else { return }
        
        let automovilSeleccionado = selectorAutomovil.titleForSegment(at: selectorAutomovil.selectedSegmentIndex)
        
        let peticion = NSFetchRequest<Automovil>(entityName: "Automovil")
        peticion.predicate = NSPredicate(format: "busqueda == %@", automovilSeleccionado!)
        //predicado: buscar todo lo que haya donde "busqueda" sea automovilSeleccionado
        do {
            let resultado = try managedContext.fetch(peticion)
            automovilActual = resultado.first
            popularDatos(automovil: automovilActual)
        } catch {
            print("No se pudo recuperar info: \(error)")
        }
    }
    
    @IBAction func probarAction(_ sender: Any) {
        let vecesProbado = automovilActual.vecesProbado
        automovilActual.vecesProbado = vecesProbado + 1 // ¿mejor ponerlo como +=?
        automovilActual.ultimaPrueba = Date()
        
        do {
            try managedContext.save()
            popularDatos(automovil: automovilActual)
        } catch {
            print("No se pudo guardar el dato nuevo: \(error)")
        }
    }
    
    @IBAction func calificarAction(_ sender: Any) {
        let alert = UIAlertController(title: "Calificación", message: "Califica el automóvil", preferredStyle: .alert)
        alert.addTextField { campoTexto in
            campoTexto.keyboardType = .decimalPad
            // teclado tipo decimal
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        let guardar = UIAlertAction(title: "Guardar", style: .default) { action in
            guard let campoTexto = alert.textFields?.first else { return }
            guard let stringCalif = campoTexto.text,
                  let calificacion = Double(stringCalif) else { return }
            self.automovilActual.calificacion = calificacion
            do {
                try self.managedContext.save()
                self.popularDatos(automovil: self.automovilActual)
            } catch let error as NSError {
                // Código en caso que la calificación sea <0 o >5
                if error.domain == NSCocoaErrorDomain && (error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError) {
                    self.calificarAction(self.automovilActual!)
                } else {
                    print("No se pudo guardar: \(error)")
                }
            }
        }
        alert.addAction(cancelar)
        alert.addAction(guardar)
        present(alert, animated: true)
    }
}

