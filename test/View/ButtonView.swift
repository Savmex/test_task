import UIKit

/**
 Custom View for displaying ButtonView from appropriate xib file.
*/

class ButtonView: UIView {

    private let cornerRadiusForButton = CGFloat(10)
    private let nibName = "ButtonView"
    private var colorForNormalButtonState = UIColor()
    private let colorForTappedButtonState = UIColor.red.withAlphaComponent(0.8)
    private let titleForNormalButtonState = "Google Search"
    private let titleForTappedButtonState = "Stop"
    
    /**
     View Controller used to respond to button action.
    */
    
    var targetForButton: DataSearchViewController!
    
    @IBOutlet weak var button: UIButton!
    
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
        button.layer.cornerRadius = cornerRadiusForButton
        colorForNormalButtonState = button.backgroundColor!
        addSubview(view)
    }
    
    /**
     Changes button state according to situation.
    */
    
    func changeButtonState(){
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
     Tells target to respond to iteractions with button.
    */
    
    @IBAction func buttonAction(_ sender: Any) {
        if button.backgroundColor == colorForNormalButtonState{
            targetForButton.searchButtonPressed(action: .start)
        }else{
            targetForButton.searchButtonPressed(action: .finish)
        }
    }
    

}
