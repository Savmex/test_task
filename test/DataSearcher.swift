import Foundation
import UIKit

/*
    class DataSearcher предназначен для получения и парсинга данных по запросу с заданным критерием
    методы searchRequest & cancelAllOperations являются public т.к используются вне класса классом ViewController
 */
class DataSearcher{
    
    private let searchURL = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBsnPhX_EwlimkglxKpjJe99lHBydcHuDs&cx=012395726208297425069:_np83nffj40&q="
    private let keysForDictionaries = KeysForFetchedDataDictionaries()
    
    
    //метод searchRequest принимает параметр запроса и получает данные по этому запросу, является internal т.к вызывается классом ViewController для получения результатов запроса по критерию
    func searchRequest(text: String)->[SearchItem]?{
        let urlAdress = searchURL + text
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
            if let items = loadedData![keysForDictionaries.keyForItems] as? [Dictionary<String,Any>]{
                for item in items{
                    let newItem = SearchItem(url: item[keysForDictionaries.keyForURL] as! String, title: item[keysForDictionaries.keyForTitle] as! String)
                    searchResults.append(newItem)
                }
            }
            else{
                return nil
            }
        
        }
        catch {
            return nil
        }
        return searchResults
    }
    
    //метод cancelAllOperations отменяет все запущенные операции в очереди, является internal т.к вызывается классом ViewController для отмены операций в очереди
    func cancelAllOperations(){
        DispatchQueue.global().suspend()
        DispatchQueue.main.suspend()
    }
}
