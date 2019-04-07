import Foundation
import UIKit

/**
 Used to handle all the operations with toast messages.
 
 Main responsibilities:
 - Preparing toast message view for displaying.
 - Loading view from nib file.
 - Displaying toast message in responce to received notification.
 */

class ToastMessageView: UIView{

    /**
     Label for toast message text.
    */
    @IBOutlet weak var textLabel: UILabel!

    private let delay = 0.1
    private let duration = 4.0
    private let options: UIView.AnimationOptions = .curveEaseOut
    private let toastLabelAlphaAtEndOfAnimation: CGFloat = 0.0
    private let toastLabelAlpha: CGFloat = 1.0
    private let nibName = "ToastMessageView"
    private let offset = CGFloat(75)
    
    private let notificationNames = NotificationNames()
    
    private let keyForMessage = "message"
    private let keyForController = "controller"
    
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
        let name = Notification.Name(notificationNames.showToastNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(showToast(notification:)), name: name, object: nil)
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
        addSubview(view)
    }
    
    @objc private func showToast(notification: Notification) {
        let parametersDictionary = notification.userInfo as! [String : Any]
        let message = parametersDictionary[keyForMessage] as! String
        let controller = parametersDictionary[keyForController] as! UIViewController
        center = CGPoint(x: controller.view.center.x - offset, y: controller.view.center.y)
        self.alpha = toastLabelAlpha
        textLabel.text = message
        textLabel.clipsToBounds  = true
        controller.view.addSubview(self)
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            self.alpha = self.toastLabelAlphaAtEndOfAnimation
        }, completion: {(isCompleted) in
            self.removeFromSuperview()
        })
    }
}
