import Foundation
import UIKit
import CoreData

class CoreDataStack {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Eateries")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addRest() {
        let context = persistentContainer.viewContext
        
        var restaurant1 = Restaurant(context: context)
        restaurant1.name = "Ogonek Grill&Bar"
        restaurant1.type = "Ресторан"
        restaurant1.location = "Moscow"
        restaurant1.image = UIImage(named: "ogonek")?.pngData()
        restaurant1.favorite = false
        
        var restaurant2 = Restaurant(context: context)
        restaurant2.name = "Елу"
        restaurant2.type = "Ресторан"
        restaurant2.location = "Moscow"
        restaurant2.image = UIImage(named: "elu")?.pngData()
        restaurant2.favorite = false
        
        var restaurant3 = Restaurant(context: context)
        restaurant3.name = "Bonsai"
        restaurant3.type = "Ресторан"
        restaurant3.location = "Moscow"
        restaurant3.image = UIImage(named: "bonsai")?.pngData()
        restaurant3.favorite = false
        
        var restaurant4 = Restaurant(context: context)
        restaurant4.name = "Дастархан"
        restaurant4.type = "Ресторан"
        restaurant4.location = "Moscow"
        restaurant4.image = UIImage(named: "dastarhan")?.pngData()
        restaurant4.favorite = false
        
        var restaurant5 = Restaurant(context: context)
        restaurant5.name = "Индокитай"
        restaurant5.type = "Ресторан"
        restaurant5.location = "Moscow"
        restaurant5.image = UIImage(named: "indokitay")?.pngData()
        restaurant5.favorite = false
        
        var restaurant6 = Restaurant(context: context)
        restaurant6.name = "Х.О"
        restaurant6.type = "Ресторан"
        restaurant6.location = "Moscow"
        restaurant6.image = UIImage(named: "x.o")?.pngData()
        restaurant6.favorite = false
        
        var restaurant7 = Restaurant(context: context)
        restaurant7.name = "Балкан Гриль"
        restaurant7.type = "Ресторан"
        restaurant7.location = "Moscow"
        restaurant7.image = UIImage(named: "balkan")?.pngData()
        restaurant7.favorite = false
        
        var restaurant8 = Restaurant(context: context)
        restaurant8.name = "Respublica"
        restaurant8.type = "Ресторан"
        restaurant8.location = "Moscow"
        restaurant8.image = UIImage(named: "respublika")?.pngData()
        restaurant8.favorite = false
        
        var restaurant9 = Restaurant(context: context)
        restaurant9.name = "Speak Easy"
        restaurant9.type = "Ресторан"
        restaurant9.location = "Moscow"
        restaurant9.image = UIImage(named: "speakeasy")?.pngData()
        restaurant9.favorite = false
        
        var restaurant10 = Restaurant(context: context)
        restaurant10.name = "Morris Pub"
        restaurant10.type = "Ресторан"
        restaurant10.location = "Moscow"
        restaurant10.image = UIImage(named: "morris")?.pngData()
        restaurant10.favorite = false
        
        var restaurant11 = Restaurant(context: context)
        restaurant11.name = "Вкусные истории"
        restaurant11.type = "Ресторан"
        restaurant11.location = "Moscow"
        restaurant11.image = UIImage(named: "istorii")?.pngData()
        restaurant11.favorite = false
        
        var restaurant12 = Restaurant(context: context)
        restaurant12.name = "Классик"
        restaurant12.type = "Ресторан"
        restaurant12.location = "Moscow"
        restaurant12.image = UIImage(named: "klassik")?.pngData()
        restaurant12.favorite = false
        
        var restaurant13 = Restaurant(context: context)
        restaurant13.name = "Love&Life"
        restaurant13.type = "Ресторан"
        restaurant13.location = "Moscow"
        restaurant13.image = UIImage(named: "love")?.pngData()
        restaurant13.favorite = false
        
        var restaurant14 = Restaurant(context: context)
        restaurant14.name = "Шок"
        restaurant14.type = "Ресторан"
        restaurant14.location = "Moscow"
        restaurant14.image = UIImage(named: "shok")?.pngData()
        restaurant14.favorite = false
        
        var restaurant15 = Restaurant(context: context)
        restaurant15.name = "Бочка"
        restaurant15.type = "Ресторан"
        restaurant15.location = "Moscow"
        restaurant15.image = UIImage(named: "bochka")?.pngData()
        restaurant15.favorite = false
        
        do { try context.save() } catch {}
    }
}
