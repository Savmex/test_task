import UIKit

/**
 Presents fetched results array.
 */

class ResultsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var results = [FetchedItem]()
    private let cellIdentifier = "resultCell"
    private let cellNibName = "ResultCell"
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp(){
        tableFooterView = UIView(frame: CGRect.zero)
        register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        dataSource = self
        delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultCell
        cell.item = results[indexPath.item]
        return cell
    }
    
    /**
     Sets values to results array.
     - parameters:
        - results: an array if fetched elements.
    */
    
    func setSearchResults(results: [FetchedItem]){
        self.results = results
    }
    
    /**
        Removes all elements from results array.
     */
    
    func removeAllSearchResults(){
        results.removeAll()
    }

}
