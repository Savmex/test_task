import UIKit

/**
 Presents fetched results.
 */

class ResultsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var searcher = DataSearcher()
    private let cellIdentifier = "resultCell"
    private let cellNibName = "ResultCell"
    
    private let notificationNames = NotificationNames()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUp()
        createObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        createObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createObservers(){
        let name = Notification.Name(rawValue: notificationNames.updateTableViewNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView(notification:)), name: name, object: nil)
    }
    
    @objc private func updateTableView(notification: Notification){
        reloadData()
    }

    private func setUp(){
        tableFooterView = UIView(frame: CGRect.zero)
        register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        dataSource = self
        delegate = self
    }
    
    /**
     - returns: number of rows in Results table view.
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = searcher.itemsCount{
            return count
        }
        else{
            return 0
        }
    }
    
    /**
     - returns: Cell of ResultCell type.
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultCell
        if let item = searcher.itemAt(index: indexPath.item){
            cell.item = item
        }
        return cell
    }
}
