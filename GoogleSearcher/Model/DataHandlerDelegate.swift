import Foundation
import UIKit

/**
 This protocol let's the delegate object to respond to data loading events.
 */

protocol DataHandlerDelegate: class {
    /**
     Called at the end of data loading.
    */
    func finishedLoading(_ dataHandler: DataHandler)
    /**
     Called at the beginning of data loading.
    */
    func startedLoading(_ dataHandler: DataHandler)
    
    /**
     Called when any data loading error occured.
    */
    func errorOccured(_ dataHandler: DataHandler, errorText: String)
    /**
     Tells delegate to perform segue to push new ViewController instance in response to iteractions with UI.
     - parameters:
        - dataHandler: DataHandler instance
        - item: data for new VC
        - segueIdentifier: identifier of segue to perform
    */
    func shouldPerformSegue(_ dataHandler: DataHandler, with item: WebPageInfoItem, with segueIdentifier: String)
}
