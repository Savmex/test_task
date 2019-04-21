import Foundation
import UIKit
import CoreData

/**
 Includes methods for converting loaded data to needed type.
*/

class DataConverter{
    
    private let keyForItems = "items"
    private let keyForURL = "formattedUrl"
    private let keyForTitle = "title"
    
    private var managedObjectContext: NSManagedObjectContext!
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = delegate.persistentContainer.viewContext
    }
    
    /**
     Converts loaded binary data of type Data to the Fetched Item array.
     
     - parameters:
        - data: binary data to convert.
     
    */
    
    func convertData(data: Data?)->[FetchedItem]?{
        var results: [FetchedItem]?
        if let fetchedData = data{
            let json = try? JSONSerialization.jsonObject(with: fetchedData, options: JSONSerialization.ReadingOptions())
            let loadedData = json as? Dictionary<String, Any>
            if let items = loadedData?[keyForItems] as? [Dictionary<String, Any>]{
                results = [FetchedItem]()
                for item in items{
                    let newItem = FetchedItem(context: managedObjectContext)
                    newItem.url = item[keyForURL] as? String
                    newItem.title = item[keyForTitle] as? String
                    results?.append(newItem)
                }
            }
        }
        return results
    }
}
