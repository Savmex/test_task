import UIKit

class SearchResultCell: UITableViewCell{
    
    var item: SearchItem?{
        didSet{
            labelForTitle.text = item?.title
            labelForLink.text = item?.url
        }
    }
    
    let labelForTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let labelForLink: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(){
        addSubview(labelForTitle)
        addSubview(labelForLink)
        
        let topOffsetForTitleLabel = CGFloat(2)
        labelForTitle.topAnchor.constraint(equalTo: topAnchor, constant: topOffsetForTitleLabel).isActive = true
        let horizontalOffsetForTitleLabel = CGFloat(2)
        labelForTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalOffsetForTitleLabel).isActive = true
        labelForTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalOffsetForTitleLabel).isActive = true
        let heightForTitleLabel = CGFloat(30)
        labelForTitle.heightAnchor.constraint(equalToConstant: heightForTitleLabel).isActive = true
        
        let topOffsetForLinkLabel = CGFloat(2)
        labelForLink.topAnchor.constraint(equalTo: labelForTitle.bottomAnchor, constant: topOffsetForLinkLabel).isActive = true
        let horizontalOffsetForLinkLabel = CGFloat(3)
        labelForLink.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalOffsetForLinkLabel).isActive = true
        labelForLink.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalOffsetForLinkLabel).isActive = true
        let heightForLinkLabel = CGFloat(24)
        labelForLink.heightAnchor.constraint(equalToConstant: heightForLinkLabel).isActive = true
    }
}
