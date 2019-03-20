import UIKit

//задает структуру для определения типа данных который будет хранить данные ячеекSearchTableView
struct SearchItem{
    var url: String
    var title: String
}

//задает enum для определения команд которые будет отправлять метод @objc func buttonPressed() класса SearchButtonView
enum Action {
    case start
    case finish
}
