import UIKit

/**
 Used to handle all events connected with text entering.
 
     Main responsibilities:
     - Handling text entering.
     - Notifying about return button pressed.
     - Returning text in responce to received notification.
     - Loading view from nib.
 */

class InputLabel: UIView, UITextFieldDelegate {
    
    /**
     Label for input.
    */
    @IBOutlet weak var textLabel: UITextField!
    
    
    private let nibName = "InputLabel"
    
    private let notificationNames = NotificationNames()
    private let errorMessages = ErrorMessages()
    
    private let keyForAction = "action"
    private let keyForText = "text"
    private let keyForMessage = "message"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        createObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        createObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createObservers(){
        let claimTextNotificationName = Notification.Name(rawValue: self.notificationNames.claimTextNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(returnText(notification:)), name: claimTextNotificationName, object: nil)
    }
    
    private func loadFromNib() -> UIView{
        var view = UIView()
        if let viewFromNib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView{
            view = viewFromNib
        }
        return view
    }
    
    private func setUp(){
        let view = loadFromNib()
        view.frame = bounds
        textLabel.delegate = self
        addSubview(view)
    }
    
    /**
     Responds to interaction with return button on keyboard.
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textLabel.resignFirstResponder()
        let actionDict: [String: Action] = [ keyForAction : .start]
        let name = Notification.Name(notificationNames.actionNotificationName)
        NotificationCenter.default.post(name: name, object: nil, userInfo: actionDict)
        return true
    }
    
    /**
     Tells
    */
    override func resignFirstResponder() -> Bool{
        textLabel.resignFirstResponder()
        return true
    }
    
    @objc private func returnText(notification: Notification){
        if let text = textLabel.text {
            if text != ""{
                let textDictionary: [String : String] = [keyForText : text]
                let name = Notification.Name(rawValue: notificationNames.textSentNotificationName)
                NotificationCenter.default.post(name: name, object: nil, userInfo: textDictionary)
            }
            else{
                notifyButtonToUpdateState()
                notifyVCToShowToastMessage(message: errorMessages.noTextInLabelError)
            }
        }
    }
    
    private func  notifyButtonToUpdateState(){
        let name = Notification.Name(rawValue: notificationNames.changeStateNotificationName)
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    private func notifyVCToShowToastMessage(message: String){
        let parametersDictionary: [String : String] = [keyForMessage : message]
        let name = Notification.Name(notificationNames.notifyVCaboutToast)
        NotificationCenter.default.post(name: name, object: nil, userInfo: parametersDictionary)
    }
}
