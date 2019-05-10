import Foundation
import CoreData

/**
 Provides interface for working with CoreData.
*/
class CoreDataStack{
    
    /**
     persistentContainer for CoreData elements.
     */
    
    private let persistentContainerName = "Model"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    /**
     Saves context in viewContext of current persistent container.
     */

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /**
     Returns current persistent container's context
    */
    
    func getContext() -> NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
}
