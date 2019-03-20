import UIKit

/*
 класс SearchButtonView включает в себя кнопку и разделительную линию,так же имеет функционал для оповещения targetForButton о том, что кнопка была нажата
 */
class SearchButtonView: UIView {
    
    private let searchButton = UIButton()
    private let bottomLine = UIView()
    private let searchButtonTextColor = UIColor.black
    private let searchButtonCornerRadius = CGFloat(10)
    private let heightsAndOffsets = HeightsAndOffsetsForVCElements()
    
    //хранит ссылку на ViewController для вызова его метода searchButtonPressed
    var targetForButton: ViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews(){
        addSubview(searchButton)
        addSubview(bottomLine)
        
        setUpSearchButton()
        setUpBottomLine()
        createSearchButtonConstraints()
        createBottomLineConstraints()
    }
    
    private func setUpSearchButton(){
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        let title = SearchButtonStatesTitles.titles.titleForNormalState
        searchButton.backgroundColor = ColorsForViewControllerElements.colors.colorForNormalButtonState
        searchButton.setTitle(title, for: .normal)
        searchButton.setTitleColor(searchButtonTextColor, for: .normal)
        searchButton.layer.cornerRadius = searchButtonCornerRadius
        searchButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
    }
    
    private func setUpBottomLine(){
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = ColorsForViewControllerElements.colors.colorForSeparatingLines
    }
    
    private func createSearchButtonConstraints(){
        let horizontalOffset = heightsAndOffsets.horizontalOffsetForSearchButton
        searchButton.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalOffset).isActive = true
        searchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalOffset).isActive = true
        let topOffset = heightsAndOffsets.topOffsetForSearchButton
        searchButton.topAnchor.constraint(equalTo: topAnchor, constant: topOffset).isActive = true
        let height = heightsAndOffsets.heightForSearchButton
        searchButton.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func createBottomLineConstraints(){
        bottomLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        let topOffset = heightsAndOffsets.bottomOffsetForSearchButton
        bottomLine.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: topOffset).isActive = true
        let height = heightsAndOffsets.heightForSeparatingLines
        bottomLine.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    //функция changeButtonState изменяет состояние кнопки в зависимости от ситуации, является internal т.к вызывается классом ViewController для изменения
    func changeButtonState(){
        if searchButton.backgroundColor == ColorsForViewControllerElements.colors.colorForNormalButtonState{
            searchButton.backgroundColor = ColorsForViewControllerElements.colors.colorForPressedButtonState
            searchButton.setTitle(SearchButtonStatesTitles.titles.titleForPressedState, for: .normal)
        }
        else{
            searchButton.backgroundColor = ColorsForViewControllerElements.colors.colorForNormalButtonState
            searchButton.setTitle(SearchButtonStatesTitles.titles.titleForNormalState, for: .normal)
        }
    }
    
    @objc private func buttonPressed(){
        if searchButton.backgroundColor == ColorsForViewControllerElements.colors.colorForNormalButtonState{
            targetForButton.searchButtonPressed(action: .start)
        }else{
            targetForButton.searchButtonPressed(action: .finish)
        }
    }
    
}
