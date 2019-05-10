import UIKit

/**
 Custom cell for displaying Item with data: url and title.
*/

class ItemCell: UITableViewCell {

    /**
     Item with data for displaying in labels.
    */
    var item: Item?{
        didSet{
            labelForTitle.text = item?.title
            labelForLink.text = item?.url
        }
    }
    
    /**
     Label for displaying item's title.
    */
    
    @IBOutlet weak var labelForTitle: UILabel!
    
    /**
     Label for displaying item's url.
     */
    @IBOutlet weak var labelForLink: UILabel!
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
