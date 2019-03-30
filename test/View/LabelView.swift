import UIKit

/**
 Custom View for displaying LabelView from appropriate xib file.
 */

class LabelView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var textLabel: UITextField!
    private let nibName = "LabelView"
    
    /**
     View Controller used to respond to Return button.
    */
    
    var target: DataSearchViewController!
    
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
        view.frame = bounds
        textLabel.delegate = self
        addSubview(view)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textLabel.resignFirstResponder()
        target.searchButtonPressed(action: .start)
        return true
    }
    
    override func resignFirstResponder() -> Bool{
        textLabel.resignFirstResponder()
        return true
    }
    
    /**
     Removes text from textLabel.
    */
    
    func removeLabelText(){
        textLabel.text?.removeAll()
    }
    
    /**
     - returns: Optional String with text from text label.
    */
    
    func getLabelText() -> String?{
        return textLabel.text
    }
}
