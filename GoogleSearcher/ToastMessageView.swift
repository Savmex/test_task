import Foundation
import UIKit

/**
A custom view appearing on screen with it's message.
 
Loads it's view from corresponding nib file.
 */

class ToastMessageView: UIView{

    /**
      for toast message text.
    */
    
    @IBOutlet weak var textLabel: UILabel!

    private let delay = 0.1
    private let duration = 4.0
    private let options: UIView.AnimationOptions = .curveEaseOut
    private let toastLabelAlphaAtEndOfAnimation: CGFloat = 0.0
    private let toastLabelAlpha: CGFloat = 1.0
    private let nibName = "ToastMessageView"
    private let offset = CGFloat(75)

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
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
    
    /**
     Displays toast message for a short period of time.
     - parameters:
        - message: error message
        - viewController: controller for displaying toast message
    */
    
    func showToast(with message: String, for viewController: UIViewController) {
        center = CGPoint(x: viewController.view.center.x - offset, y: viewController.view.center.y)
        self.alpha = toastLabelAlpha
        textLabel.text = message
        textLabel.clipsToBounds  = true
        viewController.view.addSubview(self)
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            self.alpha = self.toastLabelAlphaAtEndOfAnimation
        }, completion: {(isCompleted) in
            self.removeFromSuperview()
        })
    }
}
