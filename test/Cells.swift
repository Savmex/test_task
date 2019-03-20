import UIKit

/*
    class SearchResultCell - класс для кастомной ячейки для SearchTableView
*/

class SearchResultCell: UITableViewCell{
    
    private let parameters = ParametersForSearchResultCell()
    //item задает данные для ячейки, является internal т.к используется методом  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell класса SearchTableView для того что бы установить значение ячейки
    var item: SearchItem?{
        didSet{
            labelForTitle.text = item?.title
            labelForLink.text = item?.url
        }
    }
    
    private let labelForTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let parameters = ParametersForSearchResultCell()
        let fontSize = parameters.fontSizeForTitleLabel
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = parameters.colorForLabelForTitle
        return label
    }()
    
    private let labelForLink: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let parameters = ParametersForSearchResultCell()
        let fontSize = parameters.fontSizeForLinkLabel
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = parameters.colorForLabelForLink
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(){
        addSubview(labelForTitle)
        addSubview(labelForLink)
        
        let topOffsetForTitleLabel = parameters.topOffsetForTitleLabel
        labelForTitle.topAnchor.constraint(equalTo: topAnchor, constant: topOffsetForTitleLabel).isActive = true
        let horizontalOffsetForTitleLabel = parameters.horizontalOffsetForTitleLabel
        labelForTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalOffsetForTitleLabel).isActive = true
        labelForTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalOffsetForTitleLabel).isActive = true
        let heightForTitleLabel = parameters.heightForTitleLabel
        labelForTitle.heightAnchor.constraint(equalToConstant: heightForTitleLabel).isActive = true
        
        let topOffsetForLinkLabel = parameters.topOffsetForLinkLabel
        labelForLink.topAnchor.constraint(equalTo: labelForTitle.bottomAnchor, constant: topOffsetForLinkLabel).isActive = true
        let horizontalOffsetForLinkLabel = parameters.horizontalOffsetForLinkLabel
        labelForLink.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalOffsetForLinkLabel).isActive = true
        labelForLink.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalOffsetForLinkLabel).isActive = true
        let heightForLinkLabel = parameters.heightForLinkLabel
        labelForLink.heightAnchor.constraint(equalToConstant: heightForLinkLabel).isActive = true
    }
}
