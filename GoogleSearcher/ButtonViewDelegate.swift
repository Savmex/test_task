import Foundation
import UIKit

/**
 A set of methods to delegate some execution to object that is confirmed to protocol.
 */

protocol ButtonViewDelegate: class {
    
    /**
     Tells delegate to execute some code when button pressed.
    */
    func ButtonPressed(button: ButtonView)
}
