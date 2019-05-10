import Foundation
import UIKit

/**
A methods adopted by the object you use to provide parameters for DataHandler object.
 */

protocol DataHandlerDataSource: class {
    
    /**
     Asks the delegate to return search parameter.
    */
    
    func searchParemeter(_ forDataHandler: DataHandler) throws -> String
}
