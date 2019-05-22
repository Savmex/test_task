import Foundation
import UIKit
import CoreData

/**
 Converts loaded data of type Data to Item type acceptable for displaying on ResultsTableView.
*/

class DataConverter{
    
    private let keyForItems = "items"
    private let keyForURL = "link"
    private let keyForTitle = "title"
    
    private let coreDataStack = CoreDataStack()

    /**
     Converts loaded binary data of type Data to the Fetched Item array.
     Can throw exception if data converting fails.
     - parameters:
        - data: binary data to convert.
    */
    
    func convertData(data: Data) throws -> [WebPageInfoItem] {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options:  JSONSerialization.ReadingOptions())
            let items = try convertToItems(jsonData: json)
            return items
        }
    }
    
    private func convertToItems(jsonData: Any) throws -> [WebPageInfoItem] {
        do {
            let data = jsonData as? Dictionary<String, Any>
            if let items = data?[keyForItems] as? [Dictionary<String, Any>]{
                var results = [WebPageInfoItem]()
                for item in items{
                    let newItem = try convertItem(data: item)
                    results.append(newItem)
                }
                return results
            }
            else{
                throw DataConvertingErrors.errorGettingItems
            }
        }
    }
    
    private func convertItem(data: Dictionary<String, Any>) throws -> WebPageInfoItem{
        let newItem = WebPageInfoItem(context: coreDataStack.getContext())
        if let url = data[keyForURL] as? String{
            newItem.url = url
        }
        else{
            throw DataConvertingErrors.errorGettingItemURL
        }
        if let title = data[keyForTitle] as? String{
            newItem.title = title
        }
        else{
            throw DataConvertingErrors.errorGettingItemTitle
        }
        return newItem
    }
    
}
