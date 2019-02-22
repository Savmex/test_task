import UIKit

class SearchResultCell: UITableViewCell{
    
    var item: Item?{
        didSet{
            labelForTitle.text = item?.title
            labelForLink.text = item?.url
        }
    }
    
    let labelForTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let labelForLink: UILabel = {
        let label = UILabel()
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
        addConstraintWithFormat(format: "H:|-2-[v0]-2-|", views: labelForTitle)
        addConstraintWithFormat(format: "H:|-2-[v0]-2-|", views: labelForLink)
        addConstraintWithFormat(format: "V:|-2-[v0(30)]-2-[v1(24)]-2-|", views: labelForTitle,labelForLink)
    }
}
