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
     At the beginning of data loading.
    */
    func startedLoading(_ dataHandler: DataHandler)
    
    /**
     Called when any data loading error occured.
    */
    func errorOccured(_ dataHandler: DataHandler, errorText: String)
}
