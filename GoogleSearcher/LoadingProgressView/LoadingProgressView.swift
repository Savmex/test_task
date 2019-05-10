import UIKit

/**
 Custom view including progress view that depicts the progress of a task over time.
 
 Loads it's view from corresponding nib file.
 */

class LoadingProgressView: UIView {
    
    /**
     ProgressView for displaying current loading progress.
    */
    
    @IBOutlet weak var progressView: UIProgressView!
    
    private let nibName = "LoadingProgressView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func loadFromNib() -> UIView {
        var view = UIView()
        if let viewFromNib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView{
            view = viewFromNib
        }
        return view
    }
    
    private func setUp() {
        let view = loadFromNib()
        view.frame = bounds
        progressView.isHidden = true
        addSubview(view)
    }
    
    /**
     Sets progress in according to recieved value.
     
     - parameters:
        - value: progress value to set
    */
    
    func setProgress(value: Float) {
        progressView.setProgress(value, animated: true)
    }
    
    /**
     Hides or shows progressView according to recieved value.
     
     - parameters:
        - value: boolean value to hide/show progressView
    */
    func isProgressViewHidden(_ value: Bool) {
        switch value {
        case true:
            progressView.isHidden = true
        default:
            progressView.isHidden = false
        }
    }
}
