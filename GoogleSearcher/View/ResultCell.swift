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
    
    /**
     Label for displaying title of fetched result
    */
    
    @IBOutlet weak var labelForTitle: UILabel!
    
    /**
     Label for displaying url of fetched result
     */
    @IBOutlet weak var labelForLink: UILabel!
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
