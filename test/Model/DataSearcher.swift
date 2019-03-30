import Foundation
import UIKit
import CoreData
/**
 The DataSearcher is used to handle all the operations connected with URL requests.
 
 Main responsibilities:
    - Load, parse and return data according to parameter with Google API
 */

class DataSearcher{
    
    private let searchURL = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBsnPhX_EwlimkglxKpjJe99lHBydcHuDs&cx=012395726208297425069:_np83nffj40&q="
    private let keyForItems = "items"
    private let keyForURL = "formattedUrl"
    private let keyForTitle = "title"
    
    var managedObjectContext: NSManagedObjectContext!
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = delegate.persistentContainer.viewContext
    }
    
    /**
    Performs URL request with sent parameter.
     - returns: Array with the request results.
     - parameter text: String with search request parameter.
     */
    
    func searchRequest(text: String)->[FetchedItem]?{
        let urlAdress = searchURL + text
        let requestUrl = URL(string: urlAdress)
        var result: [FetchedItem]?
        if let url = requestUrl{
            do{
                let fetchedData =  try Data(contentsOf: url)
                if let fetchedResult = parseData(data: fetchedData){
                    result = fetchedResult
                }
            }
            catch let error{
                print(error)
            }
        }
        return result
    }
    
    private func parseData(data: Data)->[FetchedItem]?{
        var results: [FetchedItem]?
        do{
            let json = try(JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()))
            let loadedData = json as? Dictionary<String, Any>
            if let items = loadedData![keyForItems] as? [Dictionary<String,Any>]{
                results = [FetchedItem]()
                for item in items{
                    let newItem = FetchedItem(context: managedObjectContext)
                    newItem.url = item[keyForURL] as? String
                    newItem.title = item[keyForTitle] as? String
                    //let newItem = FetchedItem(url: item[keyForURL] as! String, title: item[keyForTitle] as! String)
                    results?.append(newItem)
                }
            }
        }
        catch let error{
            print(error)
        }
        return results
    }
    
    /**
     Cancels all the operations in DispatchQueues.
     */
    
    func cancelAllOperations(){
        DispatchQueue.global().suspend()
        DispatchQueue.main.suspend()
    }
}
