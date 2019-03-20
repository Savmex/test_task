import Foundation
import UIKit

//класс для хранения параметров для UI элементов исчезающего сообщения
class ToastMessageParameters{
    let widthForToastMessage = CGFloat(150)
    let heightForToastMessage = CGFloat(35)
    let fontNameForToastMessage = "Montserrat-Light"
    let toastMessageCornerRadius = CGFloat(10)
    let fontSizeForToastMessage = CGFloat(12)
    let animationDuration = 4.0
    let delay = 0.1
    let options: UIView.AnimationOptions = .curveEaseOut
    let toastLabelAlpha: CGFloat = 1.0
    let toastLabelAlphaAtStartOfAnimation: CGFloat = 0.0
    let textAllignment = NSTextAlignment.center
    let clipsToBounds = true
    
    func getX(width: CGFloat) -> CGFloat {
        return width/2 - 75
    }
    
    func getY(height: CGFloat) -> CGFloat {
        return height - 100
    }
}
