//
//  Favorite.swift
//  Eateries
//
//  Created by admin on 29.08.2022.
//

import UIKit
import CoreData

class Favorite: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var rest: [Restaurant] = []
    
    //MARK: ViewLifecycle
    
    //Выполняется один раз при инициализации VC
    override func viewDidLoad() {
        super.viewDidLoad()
        //панель убирается при скролле
        navigationController?.hidesBarsOnSwipe = true
    }
    
    //Вызвается каждый раз при показе экрана
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequest()
    }
    
    //MARK: FetchRequest
    
    //получаем данные из CoreData
    func fetchRequest(){
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let predicate = NSPredicate(format: "favorite == %@", "1")
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                rest = fetchResultController.fetchedObjects!
                print("Экран Favorite. Длина \(rest.count)")
                tableView.reloadData()
                print("Данные обновленны")
            } catch let error as NSError {
                print("Экран Favorite. Ошибка в получении данных \(error), \(error.userInfo)")
            }
        }
    }
    
    //MARK: RowAction
    
    //Дополнительные действия по свайпу
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Поедлиться
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            let defaultText = "Я сейчас в " + (self.rest[indexPath.row].name!)
            if let image = UIImage(data: self.rest[indexPath.row].image as! Data){
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        share.backgroundColor = .systemTeal
        return[share]
    }
    
    //MARK: Segue
    //Передаем данные другому VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //destination view controller - конечная точка
                let dvc = segue.destination as! Detail
                dvc.rest = self.rest[indexPath.row]
            }
        }
    }
}

//MARK: TableViewDataSource
extension Favorite {
    //количество секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //количество рядов в секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rest.count
    }
    
    //метод создает ячейку
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestsCell
        
        cell.nameLabel.text = rest[indexPath.row].name
        cell.locationLabel.text = rest[indexPath.row].location
        cell.typeLabel.text = rest[indexPath.row].type
        cell.thumbnailImageView.image = UIImage(data: self.rest[indexPath.row].image as! Data)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        return cell
    }
    
    //снимаем выделение с ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
