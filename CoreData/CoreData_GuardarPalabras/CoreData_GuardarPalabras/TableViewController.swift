//
//  TableViewController.swift
//  CoreData_GuardarPalabras
//
//  Created by Javier Rodríguez Gómez on 3/6/22.
//

import CoreData
import UIKit

class TableViewController: UITableViewController {
    // Creamos un array de entities con una sola propiedad donde se guardarán las palabras, en lugar de crear una sola entidad con array de palabras (creo que no se puede crear un atributo tipo array dentro de un entity)
    var managedObjects: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Recuperar los datos de CoreData
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lista")
        
        do {
            managedObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No puede recuperar los datos guardados: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return managedObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let managedObject = managedObjects[indexPath.row]
        cell.textLabel?.text = managedObject.value(forKey: "palabra") as? String
        return cell
    }
    
    
    @IBAction func agregarPalabras(_ sender: Any) {
        let alert = UIAlertController(title: "Nueva palabra", message: "Agrega una palabra nueva", preferredStyle: .alert)
        let guardar = UIAlertAction(title: "Agregar", style: .default) { _ in
            let textField = alert.textFields!.first!
            self.guardarPalabra(palabra: textField.text!)
            self.tableView.reloadData()
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addTextField()
        alert.addAction(guardar)
        alert.addAction(cancelar)
        present(alert, animated: true)
    }
    
    func guardarPalabra(palabra: String) {
        // Crear un moc (managed object context) a través del delegado, donde guardarlo todo
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext // este sería el moc
        
        // Crear la entidad que almacenará cada managedObject, todo en el moc anterior
        let entity = NSEntityDescription.entity(forEntityName: "Lista", in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // Crear las propiedades de cada entity
        managedObject.setValue(palabra, forKeyPath: "palabra") //la clave "palabra" es el atributo definido en el modelo de CoreData
        
        // Guardar los cambios del moc y añadir al array
        do {
            try managedContext.save()
            managedObjects.append(managedObject)
        } catch let error as NSError {
            print("No se pudo guardar: \(error), \(error.userInfo)")
        }
    }
    
}
