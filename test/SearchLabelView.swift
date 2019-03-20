import UIKit

/*
 класс SearchLabelView включает в себя view поискового лейбла и разделительные линии,так же имеет некоторый функционал для работы с текстом имеющимся в lable
 */
class SearchLabelView: UIView, UITextFieldDelegate {
    
    private let heightsAndOffsets = HeightsAndOffsetsForVCElements()
    
    private let fontSizeForLabel = CGFloat(18)
    private let placeHolderForLabel = "Search..."
    
    private let topLine = UIView()
    private let searchLabel = UITextField()
    private let bottomLine = UIView()
    
    //хранит ссылку на View controller для вызова его функции searchButtonPressed при нажатии кнопки return
    var target: ViewController!

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews(){
        addSubview(topLine)
        addSubview(searchLabel)
        addSubview(bottomLine)
        
        setUpTopLine()
        setUpSearchLabel()
        setUpBottomLine()
        createTopLineConstraints()
        createSearchLabelConstraints()
        createBottomLineConstraints()
    }
    
    private func setUpTopLine(){
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.backgroundColor = ColorsForViewControllerElements.colors.colorForSeparatingLines
    }
    
    private func setUpSearchLabel(){
        searchLabel.delegate = self
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        searchLabel.placeholder = placeHolderForLabel
        searchLabel.font = UIFont.systemFont(ofSize: fontSizeForLabel)
    }
    
    private func setUpBottomLine(){
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = ColorsForViewControllerElements.colors.colorForSeparatingLines
    }
    
    private func createTopLineConstraints(){
            topLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
            topLine.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
            topLine.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            let height = heightsAndOffsets.heightForSeparatingLines
            topLine.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func createSearchLabelConstraints(){
        let horizontalOffsets = heightsAndOffsets.horizontalOffsetForLabel
        searchLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalOffsets).isActive = true
        searchLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalOffsets).isActive = true
        searchLabel.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 0).isActive = true
        let height = heightsAndOffsets.heightForSearchLabel
        searchLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func createBottomLineConstraints(){
        bottomLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bottomLine.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 0).isActive = true
        let height = heightsAndOffsets.heightForSeparatingLines
        bottomLine.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    //обрабатывает нажатие кнопки return на клавиатуре,является internal т.к является методом протокола UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        target.searchButtonPressed(action: .start)
        searchLabel.resignFirstResponder()
        return true
    }
    
    //геттер для получения текста из скрытого члена класса searchLabel,является internal т.к вызывается в ViewController
    func getSearchLabelText() -> String? {
        return searchLabel.text
    }
    
    //удаляет весь текст из searchLabel,является internal т.к вызывается в ViewController
    func removeLabelText(){
        searchLabel.text?.removeAll()
    }
    
    //убирает клавиатуру,является internal т.к вызывается в ViewController
    override func resignFirstResponder() -> Bool {
        searchLabel.resignFirstResponder()
        return true
    }
}
