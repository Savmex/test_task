import Foundation
import UIKit

/**
 
 */

class ToastMessageView: UIView{

    @IBOutlet weak var textLabel: UILabel!

    private let delay = 0.1
    private let duration = 4.0
    private let options: UIView.AnimationOptions = .curveEaseOut
    private let toastLabelAlphaAtEndOfAnimation: CGFloat = 0.0
    private let toastLabelAlpha: CGFloat = 1.0
    private let nibName = "ToastMessageView"
    private let offset = CGFloat(75)
    
    override init(frame: CGRect) {
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
     Shows toast message.
     - parameters:
        - message: text to show.
        - controller: View Controller to show message.
    */
    
    func showToast(message : String, controller: UIViewController) {
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
