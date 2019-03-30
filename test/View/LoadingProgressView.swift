import UIKit

/**
 Custom View for displaying LoadingProgressView from appropriate xib file.
 */

class LoadingProgressView: UIView {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    private let nibName = "LoadingProgressView"
    private let valueForStartLoading = Float(0.3)
    private let valueForLoadingData = Float(0.7)
    
    
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
    
    private func setUp(){
        let view = loadFromNib()
        view.frame = bounds
        progressView.isHidden = true
        addSubview(view)
    }
    
    /**
     Sets progress value to progressView.
     */
    
    func setStartLoadingProgressValue(){
        progressView.setProgress(valueForStartLoading, animated: true)
    }
    
    /**
     Sets progress value to progressView.
     */
    
    func setLoadingDataProgressValue(){
        progressView.setProgress(valueForLoadingData, animated: true)
    }
    
    /**
     Hides or shows progressView
     - parameters:
        - result: boolean value, tells how to act.
    */
    
    func isProgressViewHidden(_ result: Bool){
        switch result {
        case true:
            progressView.isHidden = true
        default:
            progressView.isHidden = false
        }
    }
}
