//
//  About.swift
//  Eateries
//
//  Created by admin on 26.08.2022.
//

import UIKit

class About: UITableViewController {
    
    let sectionsHeader = ["Contacts"]
    let sectionsContent = [["telegram", "instagram","gitHub"]]
    let sectionLinks = ["https://t.me/bodrrovva", "https://instagram.com/bodrrovva?igshid=YmMyMTA2M2Y=", "https://github.com/bodrrovva"]
    
    //MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    //MARK: Segue
    //Передаем данные другому VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebPageSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination  as! Web
                dvc.url = URL(string: sectionLinks[indexPath.row])
            }
        }
    }
}

// MARK: - TableViewDataSource
extension About{
    //сколько секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsHeader.count
    }
    
    //titleForHeader
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsHeader[section]
    }
    
    //сколько рядов в секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsContent[section].count
    }
    
    //создаем ячейку
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //получаем номер секции и после нужный для нее контент
        cell.textLabel?.text = sectionsContent[indexPath.section][indexPath.row]
        return cell
    }
    
    //нажатие на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0..<sectionLinks.count:
                performSegue(withIdentifier: "showWebPageSegue", sender: self)
            default:
                break
            }
        default:
            break
        }
        //убираем выделение
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
