import UIKit

/**
 Custom View for displaying LoadingProgressView from appropriate xib file.
 */

class LoadingProgressView: UIView {
    
    /**
     ProgressView for displaying current loading progress.
    */
    @IBOutlet weak var progressView: UIProgressView!
    
    private let nibName = "LoadingProgressView"
    
    private let keyForIsHidden = "isHidden"
    private let keyForProgress = "progress"
    
    private let notificationNames = NotificationNames()
    
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
        let shouldHideNotificationName = Notification.Name(notificationNames.progressViewShouldHideNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(isProgressViewHidden(notification:)), name: shouldHideNotificationName, object: nil)
        let setProgressNotificationName = Notification.Name(rawValue: notificationNames.setProgressNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(setProgress(notification:)), name: setProgressNotificationName, object: nil)
    }
    
    private func loadFromNib() -> UIView {
        var view = UIView()
        if let viewFromNib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView{
            view = viewFromNib
        }
        return view
    }
    
    private func setUp(){
        let view = loadFromNib()
        view.frame = bounds
        progressView.isHidden = true
        addSubview(view)
    }
    
    @objc private func setProgress(notification: Notification){
        let progressDictionary = notification.userInfo as! [String : Float]
        let progress = progressDictionary[keyForProgress]!
        progressView.setProgress(progress, animated: true)
    }
    
    @objc private func isProgressViewHidden(notification: Notification){
        let dictionary = notification.userInfo as! [String : Bool]
        let result = dictionary[keyForIsHidden]!
        switch result {
        case true:
            progressView.isHidden = true
        default:
            progressView.isHidden = false
        }
    }
}
