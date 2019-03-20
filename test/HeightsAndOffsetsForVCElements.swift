import Foundation
import UIKit

//класс для хранения разметки UI элементов
class HeightsAndOffsetsForVCElements{
    let topOffsetForLabelView = UIApplication.shared.windows[0].safeAreaInsets.top
    let heightForLabelView = CGFloat(40)
    let heightForButtonView = CGFloat(42)
    let heightForProgressView = CGFloat(2)
    let topOffsetForProgressView = CGFloat(1)
    let topOffsetForTableView = CGFloat(1)
    let bottomOffsetForTableView = UIApplication.shared.windows[0].safeAreaInsets.bottom
    let heightForSeparatingLines = CGFloat(1)
    let heightForSearchLabel = CGFloat(38)
    let horizontalOffsetForLabel = CGFloat(20)
    let topOffsetForSearchButton = CGFloat(2)
    let horizontalOffsetForSearchButton = CGFloat(70)
    let heightForSearchButton = CGFloat(38)
    let bottomOffsetForSearchButton = CGFloat(2)
    let heightForTableViewRow = CGFloat(60)
}
