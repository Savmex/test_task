import Foundation
import UIKit

/**
Provides interface for data loading with custom search URL.
 */

class DataServer{
    
    private let customEnginePrefix = "&cx="
    private let searchQuery = "&q="
    private let equals = "="
    
    init(){
        searchURL = String()
    }
    
    init(httpRequest: String, apiKey: String, searchEngine: String){
        self.searchURL = httpRequest + equals + apiKey + customEnginePrefix + searchEngine + searchQuery
        
    }
    
    private let searchURL: String
    
    /**
     Returns loaded data.
     Can throw an exception if data loading fails.
     - parameters:
        - parameter: search criterion.
    */
    
    func searchRequest(parameter: String) throws -> Data {
        let urlAdress =  searchURL + parameter
        print(urlAdress)
        if let requestURl = URL(string: urlAdress){
            do{
                let data = try Data(contentsOf: requestURl)
                return data
            }
        }
        else{
            throw DataServerErrors.wrongURL
        }
    }

}
