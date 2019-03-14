import UIKit

/*
    class SearchResultCell - класс для кастомной ячейки для tableView
    item является public т.к используется методом  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell класса ViewController для установления значения ячейки
*/

class SearchResultCell: UITableViewCell{
    
    private let heightsAndOffsets = HeightsAndOffsetsForSearchResultCell()
    
    var item: SearchItem?{
        didSet{
            labelForTitle.text = item?.title
            labelForLink.text = item?.url
        }
    }
    
    private let labelForTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let fontSize = FontSizesForSearchResultCell.sizes.fontSizeForTitleLabel
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = ColorsForSearchResultCell.colors.colorForLabelForTitle
        return label
    }()
    
    private let labelForLink: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let fontSize = FontSizesForSearchResultCell.sizes.fontSizeForLinkLabel
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = ColorsForSearchResultCell.colors.colorForLabelForLink
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
        
        let topOffsetForTitleLabel = heightsAndOffsets.topOffsetForTitleLabel
        labelForTitle.topAnchor.constraint(equalTo: topAnchor, constant: topOffsetForTitleLabel).isActive = true
        let horizontalOffsetForTitleLabel = heightsAndOffsets.horizontalOffsetForTitleLabel
        labelForTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalOffsetForTitleLabel).isActive = true
        labelForTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalOffsetForTitleLabel).isActive = true
        let heightForTitleLabel = heightsAndOffsets.heightForTitleLabel
        labelForTitle.heightAnchor.constraint(equalToConstant: heightForTitleLabel).isActive = true
        
        let topOffsetForLinkLabel = heightsAndOffsets.topOffsetForLinkLabel
        labelForLink.topAnchor.constraint(equalTo: labelForTitle.bottomAnchor, constant: topOffsetForLinkLabel).isActive = true
        let horizontalOffsetForLinkLabel = heightsAndOffsets.horizontalOffsetForLinkLabel
        labelForLink.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalOffsetForLinkLabel).isActive = true
        labelForLink.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalOffsetForLinkLabel).isActive = true
        let heightForLinkLabel = heightsAndOffsets.heightForLinkLabel
        labelForLink.heightAnchor.constraint(equalToConstant: heightForLinkLabel).isActive = true
    }
}
