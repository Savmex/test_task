import Foundation
import UIKit
class DataSearcher{
    
    func searchRequest(text: String)->[SearchItem]?{
        let urlAdress = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBsnPhX_EwlimkglxKpjJe99lHBydcHuDs&cx=012395726208297425069:_np83nffj40&q=\(text)"
        let requestUrl = URL(string: urlAdress)
        if let url = requestUrl{
            do{
                let fetchedData =  try Data(contentsOf: url)
                if let result = parseData(data: fetchedData){
                    return result
                }
                else{
                    return nil
                }
            }
            catch let error{
                print(error)
                return nil
            }
        }
        return nil
    }
    
    private func parseData(data: Data)->[SearchItem]?{
        var searchResults = [SearchItem]()
        do{
            let json = try(JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()))
            let loadedData = json as? Dictionary<String, Any>
            if let items = loadedData!["items"] as? [Dictionary<String,Any>]{
                for item in items{
                    let newItem = SearchItem(url: item["formattedUrl"] as! String, title: item["title"] as! String)
                    searchResults.append(newItem)
                }
            }
            else{
                return nil
            }
        
        }
        catch let error{
            fatalError("error convering data: \(error)")
        }
        return searchResults
    }
    
    
    func cancelAllOperations(){
        DispatchQueue.global().suspend()
        DispatchQueue.main.suspend()
    }
}
