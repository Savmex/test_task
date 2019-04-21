import Foundation
import UIKit

/**
A set of methods that you use to manage the operations with InputField object.
 */

protocol InputFieldDelegate: class{
    /**
     Asks the delegate if the text field should process the pressing of the return button.
    */
    func inputFieldShouldReturn(inputField: InputField) -> Bool
}
