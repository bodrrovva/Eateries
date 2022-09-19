//
//  AllRests.swift
//  Eateries
//
//  Created by admin on 18.04.2022.
//

import UIKit
import CoreData

class AllRests: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var rest: [Restaurant] = []
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filteredResultArray: [Restaurant] = []
    
    
//    var restRequest = RestRequest()
    
    //MARK: ViewLifecycle
    
    //Выполняется один раз при инициализации VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //навигационная панель при скролле убирается
        navigationController?.hidesBarsOnSwipe = true
        addSubView()
        fetchRequest()
//        restRequest.getRest()
        
    }
    
    //Вызывается после того, как VC появляется на экране
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.set(true, forKey: "wasPage")
    }
    
    func addSubView() {
        //searchController
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //отключаем затемнение background при использовании search
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        //searchController остается только на этом экране
        definesPresentationContext = true
    }
    
    //MARK: FetchRequest
    
    //получаем данные из CoreData
    func fetchRequest(){
        //создаем fetch request
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //получаем context
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            
            //создаем fetch result controller
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            //пытаемся получить данные
            do {
                try fetchResultController.performFetch()
                //сохраняем данные в локальный массив
                rest = fetchResultController.fetchedObjects!
                print("Экран AllRest. Длина массива \(rest.count)")
            } catch let error as NSError {
                print("Экран AllRest. Ошибка в получении данных\(error), \(error.userInfo)")
            }
        }
    }
    
    //фильтруем общий массив ресторанов в новый массив во время поискового запросса
    func filterContentFor(searchText text:String) {
        filteredResultArray = rest.filter { (rest) -> Bool in
            //при поиске название ресторанов отображается в миниатюре
            return (rest.name?.lowercased().contains(text.lowercased()))!
        }
    }
    
    //определяем из какого массива отображать данные
    func restaurantToDisplay(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        //если поле поиска активно -> отфильтрованный массив
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredResultArray[indexPath.row]
        } else {
            //если поле поиска не активно -> все рестики
            restaurant = rest[indexPath.row]
        }
        return restaurant
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
        
        //Удалить
        let delete = UITableViewRowAction(style: .default, title: "Удалить", handler: { (action, indexPath) in
            //получаем контекст
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                //получаем объект и удаляем
                let objectToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(objectToDelete)
                //сохраняем контекст
                do {
                    try context.save()
                    self.rest = self.fetchResultController.fetchedObjects!
                    print("Объект удален")
                } catch let error as NSError {
                    print("Объект не удалось удалить \(error), \(error.userInfo)")
                }
            }
        })
        
        share.backgroundColor = .systemTeal
        delete.backgroundColor = .systemRed
        return[delete,share]
    }
    
    //MARK: TableViewAnimation
    //начинается череда изменений
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    //изменения
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            //добавить
        case .insert: guard let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: .fade)
            //удалить
        case .delete: guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
            //обновить
        case .update: guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        //успешно извлеченные объекты (fetchedObjects) записываем в сущность Restaurant
        rest = controller.fetchedObjects as! [Restaurant]
    }
    
    //череда изменений заканчивается
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        print("Экран AllRests. Обновление. Длина \(rest.count)")
    }
    
    //MARK: Segue
    //Передаем данные другому VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //destination view controller - конечная точка
                let dvc = segue.destination as! Detail
                dvc.rest = restaurantToDisplay(indexPath: indexPath)
            }
        }
    }
}

//MARK: TableViewDataSource
extension AllRests{
    
    //количество секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //количество рядов в секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        } else {
            return rest.count
        }
    }
    
    //метод создает ячейку
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestsCell
        
        let restaurant = restaurantToDisplay(indexPath: indexPath)
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.thumbnailImageView.image = UIImage(data: restaurant.image as! Data)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        return cell
    }
    
    //снимаем выделение с ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: UISearchResultsUpdating
//расширение отвечает за обновление поиска при изменении текста в поисковой строке
extension AllRests: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //вызываем метод, осуществляющий поиск
        filterContentFor(searchText: searchController.searchBar.text!)
        //обновляем таблицу
        tableView.reloadData()
    }
}

//MARK: UISearchBarDelegate
extension AllRests: UISearchBarDelegate {
    //начало редактирования текста
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //если searchBar пустой он может убираться при скролле
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    //конец редактирования тескта
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
