import UIKit

/**
 A view that presents data using rows arranged in a single column. Displays a list of data items of type Item in ItemCells.
 
 Loads it's view from corresponding nib file.
 */

class ResultsTableView: UITableView {
    
    private let cellIdentifier = "itemCell"
    private let cellNibName = "ItemCell"
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        tableFooterView = UIView(frame: CGRect.zero)
        register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
}
