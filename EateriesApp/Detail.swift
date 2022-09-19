//
//  Detail.swift
//  Eateries
//
//  Created by admin on 19.04.2022.
//

import UIKit
import UniformTypeIdentifiers

class Detail: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: @IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var heartFillButton: UIButton!
    
    var rest: Restaurant?
    
    //MARK: HeartButton
    //добавляем в избранное
    @IBAction func heartButton(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext  {
            rest!.favorite = true
            //сохраняем контекст
            do {
                try context.save()
                heartButton.isHidden = true
                heartFillButton.isHidden = false
                print("Экран Detail.Объект добавлен в избранное, контекст сохранен")
            } catch let error as NSError {
                print("Экран Detail.Объект не удалось добавить в избранное \(error), \(error.userInfo)")
            }
        } 
    }
    
    //удаляем из избранного
    @IBAction func heartFillButton(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext  {
            rest!.favorite = false
            //сохраняем контекст
            do {
                try context.save()
                heartButton.isHidden = false
                heartFillButton.isHidden = true
                print("Экран Detail.Объект удален из избранного, контекст сохранен")
            } catch let error as NSError {
                print("Экран Detail.Объект не удалось удалить из в избранного \(error), \(error.userInfo)")
            }
        }
    }
    
    //MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = rest!.name
        imageView.image = UIImage(data: rest!.image as! Data)
        
        heartFillButton.isHidden = true
        
    }
    
    //MARK: Segue
    //Передаем данные другому VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let dvc = segue.destination as! Map
            dvc.rest = self.rest
        }
    }
}

//MARK: TableViewDataSource
extension Detail {
    //количество ячеек
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //количесвто секций в ячейке
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //создаем и настраиваем ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailCell
        
        switch indexPath.row{
        case 0:
            cell.keyLabel.text = "Название"
            cell.valueLabel.text = rest!.name
        case 1:
            cell.keyLabel.text = "Тип"
            cell.valueLabel.text = rest!.type
        case 2:
            cell.keyLabel.text = "Адерс"
            cell.valueLabel.text = rest!.location
        default:
            break
        }
        return cell
    }
    
    //анимация выделения при нажатии на элемент в таблице
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
