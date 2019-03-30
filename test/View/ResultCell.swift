import UIKit

/**
 Custom cell for UITableView.
*/

class ResultCell: UITableViewCell {

    var item: FetchedItem?{
        didSet{
            labelForTitle.text = item?.title
            labelForLink.text = item?.url
        }
    }
    
    @IBOutlet weak var labelForTitle: UILabel!
    
    @IBOutlet weak var labelForLink: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
