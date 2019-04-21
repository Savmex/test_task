import UIKit

/**
 Custom view including editable text area for search parameter input.
 
 Loads it's view from corresponding nib file.
 */

class InputField: UIView, UITextFieldDelegate{
    
    /**
     Label for input.
    */
    
    @IBOutlet weak var textField: UITextField!
    
    weak open var delegate: InputFieldDelegate?
    
    private let nibName = "InputField"
    
    private let noTextInLabelError = "Enter text"
    
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
        textField.delegate = self
        addSubview(view)
    }
    
    /**
     Responds to interaction with return button on keyboard.
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let result = delegate?.inputFieldShouldReturn(inputField: self){
            return result
        }
        else{
            return false
        }
    }
    
    /**
     Tells inputField to resign first responder.
    */
    
    override func resignFirstResponder() -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    /**
     Removes text from input field.
    */
    
    func removeText(){
        textField.text?.removeAll()
    }
    
    /**
     Returns text from input field.
    */
    
    func returnText() -> String? {
        if textField.text == ""{
            return nil
        }
        else{
            return textField.text
        }
    }
    
}
