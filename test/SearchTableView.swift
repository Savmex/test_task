import UIKit

/*
 класс SearchTableView используется для отображения результатов поиска(массива searchResults)
 */
class SearchTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    var searchResults = [SearchItem]()
    private let heightsAndOffsets = HeightsAndOffsetsForVCElements()
    private let numOfSections = 1
    private let cellIdentifier = "searchResult"
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUpViews()
        
    }
    
    private func setUpViews(){
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
        tableFooterView = UIView(frame: CGRect.zero)
        register(SearchResultCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    //используется для установки значения массива searchResults извне
    func setSearchResults(results: [SearchItem]){
        searchResults = results
    }
    
    //используется для удаления значений массива searchResults извне
    func removeAllSearchResults(){
        searchResults.removeAll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //методы UITableViewDelegate,являются internal т.к соответствуют своему протоколу
    func numberOfSections(in tableView: UITableView) -> Int {
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForRow = heightsAndOffsets.heightForTableViewRow
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchResultCell
        cell.item = searchResults[indexPath.item]
        return cell
    }
}
