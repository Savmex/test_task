import Foundation
import UIKit
import CoreData
/**
 The DataSearcher is used to handle all the operations connected with URL requests.
 
 Main responsibilities:
    - Load, parse and return data according to parameter with Google API.
    - Notifying other UI elements to respond to events.
 */

class DataSearcher{
    
    private let operationQueue = OperationQueue()
    private let searchURL = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBsnPhX_EwlimkglxKpjJe99lHBydcHuDs&cx=012395726208297425069:_np83nffj40&q="
    
    private let keyForItems = "items"
    private let keyForURL = "formattedUrl"
    private let keyForTitle = "title"
    
    private let notificationNames = NotificationNames()
    private let errorMessages = ErrorMessages()

    private let keyForAction = "action"
    private let keyForText = "text"
    private let keyForProgress = "progress"
    private let keyForIsHidden = "isHidden"
    private let keyForMessage = "message"
    
    private let progressAtStartOfDataLoading =  Float(0.3)
    private let progressAtDataLoading = Float(0.7)
    
    private var managedObjectContext: NSManagedObjectContext!
    
    private var results: [FetchedItem]?
    
    /**
     - returns: element of type FetchedItem at sent index.
     - parameter index: index of type Int
    */
    
    func itemAt(index: Int)->FetchedItem?{
        if let item = results?[index]{
            return item
        }
        else{
            return nil
        }
    }
    
    /**
     Returns current number of items in fetched data array.
    */
    
    var itemsCount: Int?{
        return results?.count
    }
    
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = delegate.persistentContainer.viewContext
        createObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createObservers(){
        let nameForActionNotification = Notification.Name(rawValue: notificationNames.actionNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(buttonPressed(notification:)), name: nameForActionNotification, object: nil)
        let nameForTextNotification = Notification.Name(rawValue: notificationNames.textSentNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(searchRequest(notification:)), name: nameForTextNotification, object: nil)
    }
    
    @objc private func buttonPressed(notification: Notification){
        let actionDictionary = notification.userInfo as! [String : Action]
        let action = actionDictionary[keyForAction]!
        switch action {
        case .start:
            let name = Notification.Name(rawValue: notificationNames.claimTextNotificationName)
            NotificationCenter.default.post(name: name, object: nil)
        case .finish:
            results?.removeAll()
            cancelAllOperations()
            notifyTableViewToReload()
        }
    }
    
    @objc private func searchRequest(notification: Notification){
        let operation = BlockOperation{
            self.results?.removeAll()
            OperationQueue.main.addOperation {
                self.notifyProgressViewToHide(isHidden: false)
                self.notifyProgressViewToChangeProgress(progress: self.progressAtStartOfDataLoading)
            }
            let textDictionary = notification.userInfo as! [String : String]
            let text = textDictionary[self.keyForText]!
            let urlAdress = self.searchURL + text
            let requestUrl = URL(string: urlAdress)
            if let url = requestUrl{
                OperationQueue.main.addOperation {
                    self.notifyProgressViewToChangeProgress(progress: self.progressAtDataLoading)
                }
                let fetchedData = try? Data(contentsOf: url)
                self.results = self.parseData(data: fetchedData)
            }
            else{
                self.notifyVCToShowToastMessage(message: self.errorMessages.errorGettingData)
            }
        }
        operation.completionBlock = {
            if operation.isCancelled == false{
                OperationQueue.main.addOperation {
                    self.notifyTableViewToReload()
                    self.notifyButtonToUpdateState()
                }
            }
            OperationQueue.main.addOperation {
                self.notifyProgressViewToHide(isHidden: true)
            }
        }
        operationQueue.addOperation(operation)
    }
    
    private func  notifyButtonToUpdateState(){
        let name = Notification.Name(rawValue: notificationNames.changeStateNotificationName)
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    private func notifyTableViewToReload(){
        let name = Notification.Name(rawValue: notificationNames.updateTableViewNotificationName)
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    private func notifyProgressViewToHide(isHidden: Bool){
        let resultDictionary: [String : Bool] = [keyForIsHidden : isHidden]
        let name = Notification.Name(rawValue: notificationNames.progressViewShouldHideNotification)
        NotificationCenter.default.post(name: name, object: nil, userInfo: resultDictionary)
    }
    
    private func notifyProgressViewToChangeProgress(progress: Float){
        let progressDictionary: [String : Float] = [keyForProgress : progress]
        let name = Notification.Name(rawValue: notificationNames.setProgressNotificationName)
        NotificationCenter.default.post(name: name, object: nil, userInfo: progressDictionary)
    }
    
    private func notifyVCToShowToastMessage(message: String){
        let parametersDictionary: [String : String] = [keyForMessage : message]
        let name = Notification.Name(notificationNames.notifyVCaboutToast)
        NotificationCenter.default.post(name: name, object: nil, userInfo: parametersDictionary)
    }
    
    private func parseData(data: Data?)->[FetchedItem]?{
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

    private func cancelAllOperations(){
        operationQueue.cancelAllOperations()
        OperationQueue.main.cancelAllOperations()
    }
}
