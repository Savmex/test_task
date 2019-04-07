import UIKit
import Foundation
import CoreData

/**
 
 The ViewController class defines the shared behavior that is common to all view controllers.
 Used to display main app window.
 
 Main responsibilities:
    - In response to dataSearcher, updating the contents of the views:
        - labelView
        - buttonView
        - progressView
        - tableView
    - Responding to user interactions views.
    - Сoordinating with:
        - dataSearcher
        - toastMessageView
        - errorMessages
 */

class DataSearchViewController: UIViewController{
    
    private var toastMessageView: ToastMessageView!
    private var notificationNames: NotificationNames!
    
    private let actionNotificationName = "actionNotification"
    
    private let keyForAction = "action"
    private let keyForMessage = "message"
    private let keyForController = "controller"
    
    /**
     Handles additional initialization.
    */
    override func viewDidLoad(){
        super.viewDidLoad()
        initComponents()
        createObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initComponents(){
        notificationNames = NotificationNames()
        toastMessageView = ToastMessageView(frame: CGRect.null)
    }
    
    private func createObservers(){
        let name = Notification.Name(rawValue: notificationNames.notifyVCaboutToast)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyToShowToast(notification:)), name: name, object: nil)
    }
    
    @objc private func notifyToShowToast(notification: Notification){
        let messageDictionary = notification.userInfo as! [String : String]
        let message = messageDictionary[keyForMessage]!
        var toastMessageDictionary = [String : Any]()
        toastMessageDictionary[keyForMessage] = message
        toastMessageDictionary[keyForController] = self
        let name = Notification.Name(rawValue: notificationNames.showToastNotificationName)
        NotificationCenter.default.post(name: name, object: nil, userInfo: toastMessageDictionary)
    }
}




