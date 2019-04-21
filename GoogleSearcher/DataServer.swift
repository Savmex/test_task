import Foundation
import UIKit

/**
Provides interface for data loading.
 */

class DataServer{
    
    private let searchURL = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBsnPhX_EwlimkglxKpjJe99lHBydcHuDs&cx=012395726208297425069:_np83nffj40&q="
    
    /**
     Returns loaded data.
     
     - parameters:
        - parameter: search criterion.
    */
    
    func searchRequest(parameter: String) -> Data? {
        let urlAdress = self.searchURL + parameter
        let requestURL = URL(string: urlAdress)
        var data: Data?
        if let url = requestURL{
            data = try? Data(contentsOf: url)
        }
        return data
    }

}
