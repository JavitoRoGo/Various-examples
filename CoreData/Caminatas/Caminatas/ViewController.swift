//
//  ViewController.swift
//  Caminatas
//
//  Created by Javier Rodríguez Gómez on 12/6/22.
//

import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var managedContext: NSManagedObjectContext!
    
    var currentPerson: Person?
    
    // IBOutles
    @IBOutlet weak var caminataTableView: UITableView!
    
    
    // UIView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caminataTableView.delegate = self
        caminataTableView.dataSource = self
        
        let personName = "Yo"
        let personFetch: NSFetchRequest<Person> = Person.fetchRequest()
        personFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Person.name), personName)
        // lo anterior significa que vamos a comparar K con @, cuyos valores son los que siguen después de las comas
        do {
            let resultados = try managedContext.fetch(personFetch)
            if resultados.count > 0 {
                // Se ha encontrado una persona con ese nombre; la usamos
                currentPerson = resultados.first
            } else {
                // No se ha encontrado ninguna persona; la creamos
                currentPerson = Person(context: managedContext)
                currentPerson?.name = personName
                try managedContext.save()
            }
        } catch let error as NSError {
            print(("Algo falló: \(error.localizedDescription)"))
        }
    }
    
    
    // System functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let caminatas = currentPerson?.caminatas else { return 1 }
        return caminatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCaminatas", for: indexPath)
        guard let caminata = currentPerson?.caminatas?[indexPath.row] as? CadaCaminata,
              let fecha = caminata.date else { return cell }
        cell.textLabel?.text = dateFormatter.string(from: fecha)
        return cell
    }
    
    // Eliminar datos
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let caminataAEliminar = currentPerson?.caminatas?[indexPath.row] as? CadaCaminata,
              editingStyle == .delete else { return }
        managedContext.delete(caminataAEliminar)
        do {
            try managedContext.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            // error
        }
    }
    
    
    // IBActions
    @IBAction func addCaminata(_ sender: Any) {
        // Crear caminata
        let caminata = CadaCaminata(context: managedContext)
        caminata.date = Date()
        
        // Asignar caminata a Person
        if let persona = currentPerson,
           let caminatas = persona.caminatas?.mutableCopy() as? NSMutableOrderedSet {
            caminatas.add(caminata)
            persona.caminatas = caminatas
        }
        
        // Guardar
        do {
            try managedContext.save()
        } catch {
            // error
        }
        
        caminataTableView.reloadData()
    }
}

