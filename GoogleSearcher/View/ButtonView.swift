import UIKit

/**
 Coordinates all the interaction with button.
 
Main responsibilities:
 - Notifying about interactions with button.
 - Loading view from nib file.
 - Changing button state in responce to received notification.
*/

class ButtonView: UIView {

    private let cornerRadiusForButton = CGFloat(10)
    private let nibName = "ButtonView"
    private var colorForNormalButtonState = UIColor()
    private let colorForTappedButtonState = UIColor.red.withAlphaComponent(0.8)
    private let titleForNormalButtonState = "Google Search"
    private let titleForTappedButtonState = "Stop"

    private let notificationNames = NotificationNames()
    private let keyForActionDictionary = "action"
    
    @IBOutlet weak var button: UIButton!
    
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
        let name = Notification.Name(notificationNames.changeStateNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(changeButtonState), name: name, object: nil)
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
        button.layer.cornerRadius = cornerRadiusForButton
        colorForNormalButtonState = button.backgroundColor!
        addSubview(view)
    }
    
    @objc private func changeButtonState(){
        if button.backgroundColor == colorForNormalButtonState{
            button.backgroundColor = colorForTappedButtonState
            button.setTitle(titleForTappedButtonState, for: .normal)
        }
        else{
            button.backgroundColor = colorForNormalButtonState
            button.setTitle(titleForNormalButtonState, for: .normal)
        }
    }
    
    /**
     Sends notification to LabelView if button pressed.
    */
    
    @IBAction func buttonAction(_ sender: Any) {
        if button.backgroundColor == colorForNormalButtonState{
            changeButtonState()
            let actionDict: [String: Action] = [keyForActionDictionary : .start]
            let name = Notification.Name(notificationNames.actionNotificationName)
            NotificationCenter.default.post(name: name, object: nil, userInfo: actionDict)
        }
        else{
            changeButtonState()
            let actionDict: [String: Action] = [keyForActionDictionary : .finish]
            let name = Notification.Name(notificationNames.actionNotificationName)
            NotificationCenter.default.post(name: name, object: nil, userInfo: actionDict)
        }
    }

}
